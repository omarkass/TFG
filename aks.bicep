@description('The name of the Managed Cluster resource.')
param resourceName string

@description('The location of AKS resource.')
param location string

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@description('Disk size (in GiB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The version of Kubernetes.')
param kubernetesVersion string = '1.7.7'

@description('Network plugin used for building Kubernetes network.')
@allowed([
  'azure'
  'kubenet'
])
param networkPlugin string

@description('Boolean flag to turn on and off of RBAC.')
param enableRBAC bool = true

@description('Boolean flag to turn on and off of virtual machine scale sets')
param vmssNodePool bool = false

@description('Boolean flag to turn on and off of virtual machine scale sets')
param windowsProfile bool = false

@description('The name of the resource group containing agent pool nodes.')
param nodeResourceGroup string

@description('An array of AAD group object ids to give administrative access.')
param adminGroupObjectIDs array = []

@description('Enable or disable Azure RBAC.')
param azureRbac bool = false

@description('Enable or disable local accounts.')
param disableLocalAccounts bool = false

@description('Enable private network access to the Kubernetes cluster.')
param enablePrivateCluster bool = false

@description('Boolean flag to turn on and off http application routing.')
param enableHttpApplicationRouting bool = true

@description('Boolean flag to turn on and off Azure Policy addon.')
param enableAzurePolicy bool = false

@description('Boolean flag to turn on and off secret store CSI driver.')
param enableSecretStoreCSIDriver bool = false

@description('Boolean flag to turn on and off omsagent addon.')
param enableOmsAgent bool = true

@description('Specify the region for your OMS workspace.')
param workspaceRegion string = 'East US'

@description('Specify the name of the OMS workspace.')
param workspaceName string

@description('Specify the resource id of the OMS workspace.')
param omsWorkspaceId string

@description('Select the SKU for your workspace.')
@allowed([
  'free'
  'standalone'
  'pernode'
])
param omsSku string = 'standalone'

module WorkspaceDeployment_20220907084232 './nested_WorkspaceDeployment_20220907084232.bicep' = {
  name: 'WorkspaceDeployment-20220907084232'
  scope: resourceGroup(split(omsWorkspaceId, '/')[2], split(omsWorkspaceId, '/')[4])
  params: {
    workspaceRegion: workspaceRegion
    workspaceName: workspaceName
    omsSku: omsSku
  }
}

resource resourceName_resource 'Microsoft.ContainerService/managedClusters@2022-06-01' = {
  location: location
  name: resourceName
  properties: {
    kubernetesVersion: kubernetesVersion
    enableRBAC: enableRBAC
    dnsPrefix: dnsPrefix
    nodeResourceGroup: nodeResourceGroup
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: 1
        enableAutoScaling: false
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        maxPods: 110
        availabilityZones: [
          '1'
        ]
        nodeTaints: []
        enableNodePublicIP: false
        tags: {
        }
      }
    ]
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPlugin: networkPlugin
    }
    disableLocalAccounts: disableLocalAccounts
    apiServerAccessProfile: {
      enablePrivateCluster: enablePrivateCluster
    }
    addonProfiles: {
      httpApplicationRouting: {
        enabled: enableHttpApplicationRouting
      }
      azurepolicy: {
        enabled: enableAzurePolicy
      }
      azureKeyvaultSecretsProvider: {
        enabled: enableSecretStoreCSIDriver
        config: null
      }
      omsAgent: {
        enabled: enableOmsAgent
        config: {
          logAnalyticsWorkspaceResourceID: omsWorkspaceId
        }
      }
    }
  }
  tags: {
  }
  sku: {
    name: 'Basic'
    tier: 'Paid'
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    WorkspaceDeployment_20220907084232
  ]
}

output controlPlaneFQDN string = resourceName_resource.properties.fqdn