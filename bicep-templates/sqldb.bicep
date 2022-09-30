param name string 
param location string 
param projTagValue string
param logAnaliticResourceGroup string
param logAnaliticName string
param skuName string
param skuTier string
param skuCapacity int
param collation string
param catalogCollation string

resource azureSqlServer 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }

  sku: {
    name: skuName //'Basic'
    tier: skuTier//'Basic'
    capacity: skuCapacity //5
}

properties: {
  collation: collation //'SQL_Latin1_General_CP1_CI_AS'
  maxSizeBytes: 2147483648
  catalogCollation: catalogCollation//'SQL_Latin1_General_CP1_CI_AS'
  zoneRedundant: false
  readScale: 'Disabled'
  requestedBackupStorageRedundancy: 'Local'
  isLedgerOn: false
}
}


resource DiagnosticSetting 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'sql-db-ds'
  // this is where you enable diagnostic setting for the specificed security group
  scope: azureSqlServer
  properties: {
    workspaceId: resourceId(logAnaliticResourceGroup,'Microsoft.OperationalInsights/workspaces',logAnaliticName)
    logs: [

      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    
    ]
    metrics: [{
      category: 'AllMetrics'
      enabled: true
  }]
  }
}
