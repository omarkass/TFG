param name string
param location string 
param StorageAcountName string
param planName string
param applicationInsightName string 
resource azureFunctionName 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  location: location
  tags: {
    'hidden-link: /app-insights-resource-id': resourceId('Microsoft.Insights/components/',applicationInsightName)
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
