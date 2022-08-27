param name string 
param location string 
param aksName string 
param projTagValue string


var kubeletPrincipalId = reference(resourceId('Microsoft.ContainerService/managedClusters/',aksName), '2020-03-01').identityProfile.kubeletidentity.objectId


resource azureContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  tags:{
    proj:projTagValue
  }
  properties: {
    adminUserEnabled: false
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
  }
}



resource acrName_Microsoft_Authorization_acrName 'Microsoft.ContainerRegistry/registries/providers/roleAssignments@2018-09-01-preview' = {
  name: '${name}/Microsoft.Authorization/${guid(name)}'
  properties: {
    roleDefinitionId:'/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/7f951dda-4ed3-4680-a7ca-43fe172d538d'
    principalId: kubeletPrincipalId
  }
  dependsOn:[
    azureContainerRegistry
  ]
}
