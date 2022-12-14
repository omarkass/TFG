param name string 
param location string 
param projTagValue string

resource azurelogAnalytics 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: name
  location: location
  tags: {
    deployedby:projTagValue
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: 1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}
