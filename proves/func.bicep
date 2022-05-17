var storageAccountName_var = '${uniqueString(resourceGroup().id)}azfunctions'

resource storageAccountName 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName_var
  location: 'Central US'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource proj_dev_func 'Microsoft.Web/sites@2018-11-01' = {
  name: 'proj-dev-func'
  kind: 'functionapp,linux'
  location: 'Central US'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/2c02e9f9-7fad-4208-82e1-4e97500b5e0e/resourceGroups/proj-dev-func_group/providers/Microsoft.Insights/components/proj-dev-func-appi'
  }
  properties: {
    name: 'proj-dev-func'
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccountName.id, '2021-08-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccountName.id, '2021-08-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('ASP-projdevfuncgroup-a4d1')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('microsoft.insights/components/proj-dev-func-appi', '2015-05-01').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference('microsoft.insights/components/proj-dev-func-appi', '2015-05-01').ConnectionString
        }
        {
          name: 'AzureWebJobsSecretStorageType'
          value: 'files'
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
    serverFarmId: '/subscriptions/2c02e9f9-7fad-4208-82e1-4e97500b5e0e/resourcegroups/proj-dev-func_group/providers/Microsoft.Web/serverfarms/ASP-projdevfuncgroup-a4d1'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
  }
  dependsOn: [
    proj_dev_func_appi
    ASP_projdevfuncgroup_a4d1
  ]
}

resource ASP_projdevfuncgroup_a4d1 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: 'ASP-projdevfuncgroup-a4d1'
  location: 'Central US'
  kind: 'linux'
  tags: null
  properties: {
    name: 'ASP-projdevfuncgroup-a4d1'
    workerSize: '0'
    workerSizeId: '0'
    numberOfWorkers: '1'
    reserved: true
  }
  sku: {
    Tier: 'Dynamic'
    Name: 'Y1'
  }
  dependsOn: []
}

resource proj_dev_func_appi 'microsoft.insights/components@2020-02-02-preview' = {
  name: 'proj-dev-func-appi'
  location: 'centralus'
  dependsOn: [
    DefaultWorkspace_2c02e9f9_7fad_4208_82e1_4e97500b5e0e_CUS
  ]
  tags: null
  properties: {
    ApplicationId: 'proj-dev-func'
    Request_Source: 'IbizaWebAppExtensionCreate'
    Flow_Type: 'Redfield'
    Application_Type: 'web'
    WorkspaceResourceId: '/subscriptions/2c02e9f9-7fad-4208-82e1-4e97500b5e0e/resourceGroups/DefaultResourceGroup-CUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-2c02e9f9-7fad-4208-82e1-4e97500b5e0e-CUS'
  }
}

resource DefaultWorkspace_2c02e9f9_7fad_4208_82e1_4e97500b5e0e_CUS 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: 'DefaultWorkspace-2c02e9f9-7fad-4208-82e1-4e97500b5e0e-CUS'
  location: 'Central US'
  properties: {}
}
