param name string 
param location string 
param projTagValue string

resource azureSqlServer 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}
