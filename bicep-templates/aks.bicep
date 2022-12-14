param name string
param location string 
param version string
param VmSize string
param projTagValue string
param logAnalyticsName string
param logAnaliticResourceGroup string
param workerNumber int

resource azureakscluster 'Microsoft.ContainerService/managedClusters@2021-07-01' = {
  name: name
  location: location
  tags: { 
    deployedby:projTagValue
  }
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: version
    enableRBAC: true
    dnsPrefix: 'dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0
        count: workerNumber
        enableAutoScaling: false
        vmSize: VmSize
        osType: 'Linux'
        //storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        maxPods: 110
        availabilityZones: []
        enableNodePublicIP: false
        tags: {}
      }
    ]
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPlugin: 'kubenet'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false
    }
    addonProfiles: {
      httpApplicationRouting: {
        enabled: true
      }
      azurepolicy: {
        enabled: false
      }
      azureKeyvaultSecretsProvider: {
        enabled: false
        config: null
      }
      omsAgent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: resourceId(logAnaliticResourceGroup,'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
        }
      }
    }
  }
}
