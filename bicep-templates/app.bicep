param name string 
param location string
param planeName string 
param projTagValue string
param logAnaliticResourceGroup string
param logAnaliticName string


resource azureWebApp 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }
  properties: {
    name: name
    siteConfig: {
      appSettings: []
      linuxFxVersion: 'PYTHON|3.9'
      alwaysOn: false
    }
    serverFarmId: resourceId('Microsoft.Web/serverfarms',planeName)//'/subscriptions/${subscriptionId}/resourcegroups/${azureWebAppRgName}/providers/Microsoft.Web/serverfarms/${azureServicePlanWebAppName}'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
  }
}
resource DiagnosticSetting 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'plan-ds'
  // this is where you enable diagnostic setting for the specificed security group
  scope: azureWebApp
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
