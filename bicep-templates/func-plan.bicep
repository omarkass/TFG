param name string
param location string
param skuFunction string
param skuCodeFunction string
param numberOfWorkers string

resource azureServicePlanFunction 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: name
  location: location
  sku: {
    Tier: skuFunction
    Name: skuCodeFunction
  }
  kind: 'linux'
  properties: {
    name: name
    workerSize: '0'
    workerSizeId: '0'
    numberOfWorkers: numberOfWorkers
    reserved: true
  }
}
