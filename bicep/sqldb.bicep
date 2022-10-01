param name string 
param location string 
param projTagValue string
param logAnaliticResourceGroup string
param logAnaliticName string

resource azureSqlServer 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }

  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
}

properties: {
  collation: 'SQL_Latin1_General_CP1_CI_AS'
  maxSizeBytes: 2147483648
  catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
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
        category: 'SQLInsights'
        enabled: true
        }
        {
        category: 'AutomaticTuning'
        enabled: true
        }
        {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
        }
        {
        category: 'QueryStoreWaitStatistics'
        enabled: true
        }
        {
        category: 'Errors'
        enabled: true
        }
        {
        category: 'DatabaseWaitStatistics'
        enabled: true
        }
        {
        category: 'Timeouts'
        enabled: true
        }
        {
        category: 'Blocks'
        enabled: true
        }
        {
        category: 'Deadlocks'
        enabled: true
        }
        {
        category: 'SQLSecurityAuditEvents'
        enabled: true
        }
    
    ]
    metrics: [{
      category: 'AllMetrics'
      enabled: true
  }]
  }
}