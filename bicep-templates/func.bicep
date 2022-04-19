param name string
param location string 
param subscriptionId string 
param StorageAcountName string
param rgName string
param planName string

resource azureFunctionName 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  location: location
  tags: {}
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
          value: 'DefaultEndpointsProtocol=https;AccountName=${StorageAcountName};AccountKey=${listKeys(resourceId(subscriptionId, rgName, 'Microsoft.Storage/storageAccounts', StorageAcountName), '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
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
    serverFarmId: '/subscriptions/${subscriptionId}/resourcegroups/${rgName}/providers/Microsoft.Web/serverfarms/${planName}'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
  }
}