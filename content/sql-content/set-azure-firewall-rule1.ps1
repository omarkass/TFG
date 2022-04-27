[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
  [String] [Parameter(Mandatory = $true)] $ServerName,
  [String] [Parameter(Mandatory = $true)] $ResourceGroupName,
  [String] $AzureFirewallName = "AzureWebAppFirewall"
)

$ErrorActionPreference = 'Stop'

function New-AzureSQLServerFirewallRule {
  $agentIP = (New-Object net.webclient).downloadstring("https://api.ipify.org")
  New-AzureSqlDatabaseServerFirewallRule -StartIPAddress $agentIp -EndIPAddress $agentIp -FirewallRuleName $AzureFirewallName -ServerName $ServerName -ResourceGroupName $ResourceGroupName
}
function Update-AzureSQLServerFirewallRule{
  $agentIP= (New-Object net.webclient).downloadstring("https://api.ipify.org")
  Set-AzureSqlDatabaseServerFirewallRule -StartIPAddress $agentIp -EndIPAddress $agentIp -FirewallRuleName $AzureFirewallName -ServerName $ServerName -ResourceGroupName $ResourceGroupName
}

If ((Get-AzureSqlDatabaseServerFirewallRule -ServerName $ServerName -FirewallRuleName $AzureFirewallName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue) -eq $null)
{
  New-AzureSQLServerFirewallRule
}
else
{
  Update-AzureSQLServerFirewallRule
}