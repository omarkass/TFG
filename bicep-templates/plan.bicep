param name string
param location string
param sku string
param skuCode string
param numberOfWorkers string
param projTagValue string
resource azureServicePlanFunction 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: name
  location: location
  sku: {
    tier: sku
    name: skuCode
  }
  tags: {
    deployedby:projTagValue
  }
  kind: 'linux'
  properties: {
    name: name
    workerSize: '0'
    workerSizeId: '0'
    numberOfWorkers: numberOfWorkers
    reserved: true
    zoneRedundant: false
  }
}

