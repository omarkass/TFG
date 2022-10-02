param name string
param location string 
param StorageAcountName string
param planName string
param logAnaliticName string 
param logAnaliticResourceGroup string
param projTagValue string
resource azureFunction 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }
  kind: 'functionapp,linux'
  properties: {
    name: name
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${StorageAcountName};AccountKey=${listKeys(resourceId('Microsoft.Storage/storageAccounts', StorageAcountName), '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${StorageAcountName};AccountKey=${listKeys(resourceId('Microsoft.Storage/storageAccounts', StorageAcountName), '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'AzureWebJobsSecretStorageType'
          value: 'files'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(planName)
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      use32BitWorkerProcess: false
      linuxFxVersion: 'Python|3.9'
    }
    serverFarmId:  resourceId('Microsoft.Web/serverfarms/',planName)   //'/subscriptions/${subscriptionId}/resourcegroups/${rgName}/providers/Microsoft.Web/serverfarms/${planName}'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
  }
}



resource DiagnosticSetting 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'sql-db-ds'
  // this is where you enable diagnostic setting for the specificed security group
  scope: azureFunction
  properties: {
    workspaceId: resourceId(logAnaliticResourceGroup,'Microsoft.OperationalInsights/workspaces',logAnaliticName)
    logs: [

      {
        categoryGroup: 'FunctionApplicationLogs'
        enabled: true
      }
    
    ]
    metrics: [{
      category: 'AllMetrics'
      enabled: true
  }]
  }
}
