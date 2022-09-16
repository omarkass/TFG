param name string
param location string
param SQL_User string 
param SQL_Pass string 
param projTagValue string



resource azureSqlDatabase 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: name
  location: location
  tags: {
    displayName: 'SQL'
    deployedby:projTagValue
  }
  kind: 'v12.0'
  properties: {
    administratorLogin: SQL_User
    administratorLoginPassword: SQL_Pass
    version: '12.0'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

