param skuFunction string = 'Dynamic'
param skuCodeFunction string = 'Y1'
param locationAzureFunction string = 'East US'
param numberOfWorkersFunction string = '1'
param azureFunctionRgName string = 'func-rg'
param azureServicePlanFunction string = 'func-plan'
param projTagValue string = 'proj'

param locationLogAnalytics string = 'East US'
param azurekLogAnalyticsRgName string = 'log-rg'
param logAnalyticName string = 'logAnaytics'

param deployFunc bool = true

targetScope = 'subscription'

var AzureSqlRuleName = 'AllowAllWindowsAzureIps'

var acrName = '${uniqueString(subscription().subscriptionId)}aksacr'

var azureWebAppName = '${uniqueString(subscription().subscriptionId)}-app'

var azureFunctionName ='${uniqueString(subscription().subscriptionId)}-func'
var azureStorageAcountFunction = '${uniqueString(subscription().subscriptionId)}funcst'

var applicationInsghtsName = 'func-appi'


resource func_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployFunc){
  name: azureFunctionRgName
  location: locationAzureFunction
}

resource log_rg 'Microsoft.Resources/resourceGroups@2021-01-01'={
  name: azurekLogAnalyticsRgName
  location: locationLogAnalytics
}


// Deploy the storage account to be used in Azure Function.
module func_st './bicep-templates/func-st.bicep' = if(deployFunc) {
  name: 'func_st'
  scope: func_rg    
  params: {
    name: azureStorageAcountFunction
    location:locationAzureFunction
    projTagValue:projTagValue
  }
}

// Deploy the Service App plan to be used with Azure Function.
module func_plan './bicep-templates/plan.bicep' = if(deployFunc)  {
  name: 'func_plan'
  scope: func_rg    
  params: {
    name: azureServicePlanFunction
    location:locationAzureFunction
    sku: skuFunction
    skuCode: skuCodeFunction
    numberOfWorkers : numberOfWorkersFunction
    projTagValue:projTagValue
  }
}


// Deploy log analysis to gather logs from the other resources.
module log 'bicep-templates/log.bicep' =  {
  name: logAnalyticName
  scope: log_rg
  params:{
    name: logAnalyticName
    location: locationLogAnalytics
    projTagValue:projTagValue
  }
}

// Deploy the application insight for Azure Function, to enable direct logs feature inside Azure Function.
module func_appi 'bicep-templates/func-appi.bicep' = if(deployFunc) {
  name : 'func_appi'
  scope: func_rg 
  params:{
    name: applicationInsghtsName
    location: locationAzureFunction
    azureFunctionName: azureFunctionName
    projTagValue:projTagValue
    logAnaliticName: logAnalyticName
    logAnaliticResourceGroup: azurekLogAnalyticsRgName
  }
  dependsOn:[
    log
  ]
}

//Deploy the Azure Function.
module func 'bicep-templates/func.bicep' = if(deployFunc) {
  name: 'func'
  scope: func_rg   
  params: {
    name: azureFunctionName
    location:locationAzureFunction
    planName: azureServicePlanFunction
    StorageAcountName: azureStorageAcountFunction
    applicationInsightName:applicationInsghtsName
    projTagValue:projTagValue
  }
  dependsOn:[
    func_plan
    func_appi
  ]
}
