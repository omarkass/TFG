param name string 
param location string
param subscriptionId string
param azureWebAppRgName string
param planeName string 

resource azureWebApp 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  location: location
  tags: {}
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
