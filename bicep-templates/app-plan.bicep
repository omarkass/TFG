param name string
param location string 


resource azureServicePlanWebApp 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: name
  location: location
  tags: {}
  sku: {
    tier: 'Free'
    name: 'F1'
  }
  kind: 'linux'
  properties: {
    name: name
    workerSize: 0
    workerSizeId: 0
    numberOfWorkers: 1
    reserved: true
    zoneRedundant: false
  }
  dependsOn: []
}
