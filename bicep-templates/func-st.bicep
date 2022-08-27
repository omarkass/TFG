
param name string
param location string
param projTagValue string
/*
param storageAccountName string
resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
*/

resource azureStorageAcountFunction 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}


