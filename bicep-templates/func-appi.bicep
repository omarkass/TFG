param name string
param location string 
param logAnaliticName string
param azureFunctionName string
param projTagValue string

resource AzureapplicationInsghts 'microsoft.insights/components@2020-02-02-preview' = {
  name: name
  location:  location 
  kind: 'web'
  tags: {
    proj:projTagValue
  }
  properties: {
    ApplicationId: azureFunctionName
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaWebAppExtensionCreate'
    RetentionInDays: 30
    WorkspaceResourceId: resourceId('microsoft.operationalinsights/workspaces',logAnaliticName)
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource applicationInsghtsName_Basic 'Microsoft.Insights/components/CurrentBillingFeatures@2015-05-01' = {
  parent: AzureapplicationInsghts
  name: 'Basic'
  location: location 
  properties: {
    CurrentBillingFeatures: 'Basic'
    DataVolumeCap: {
      Cap: 5
      WarningThreshold: 90
      ResetTime: 23
    }
  }
}
