param serverName string 
param name string 

resource azureSqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  name: '${serverName}/${name}'
}
