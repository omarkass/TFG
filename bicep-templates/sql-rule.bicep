param serverName string 
param name string 
param location string

resource azureSqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2014-04-01-preview' = {
  kind: 'v12.0'
  name: '${serverName}/${name}'
  location: location
  scale: null
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
