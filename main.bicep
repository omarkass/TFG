targetScope = 'subscription'
//parameters 

// kubernetes parameters
param locationAks string //= 'Korea Central'
param aksNumberOfWorkers int //= 1
param kubernetesVersion string// = '1.22.11'
param aksVmSize string //= 'standard_b2s'
param aksName string //= 'aks'
param aksRgName string //= 'aks-rg'

//function parameters 
param skuFunction string //= 'Dynamic'
param skuCodeFunction string //= 'Y1'
param locationAzureFunction string //= 'East US'
param numberOfWorkersFunction string //= '1'
param azureFunctionRgName string //= 'func-rg'
param azureServicePlanFunction string //= 'func-plan'

//webapp parameters
param locationWebApp string //= 'East US'
param skuWebApp string //= 'Free'
param skuCodeskuWebApp string //= 'F1'
param numberOfWorkersWebApp string //= '1'
param azureWebAppRgName string //= 'app-rg'
param azureServicePlanWebApp string //= 'app-plan'

//sql parameters
param sqlRgName string //= 'sql-rg'
param sqlDbName string //= 'sqldb'
@minLength(5)
param SQL_User string //= 'omar1'
@minLength(5)
param SQL_Pass string //= 'Kassar@14689'
param locationSqlDatabase string //= 'East US'
param sqlSkuName string // Basic
param sqlSkuTier string //  Basic
param sqlSkuCapacity int // 5
param sqlCollation string // 'SQL_Latin1_General_CP1_CI_AS'
param sqlCatalogCollation string // 'SQL_Latin1_General_CP1_CI_AS'


//loganalytics parameters
param locationLogAnalytics string //= 'East US'
param azurekLogAnalyticsRgName string //= 'log-rg'
param logAnalyticName string //= 'logAnaytics'

param projTagValue string //= 'proj'

param deployAks bool //= true
param deployFunc bool //= true
param deployApp bool //= true
param deploySql bool //= false




var AzureSqlRuleName = 'AllowAllWindowsAzureIps'

var acrName = '${uniqueString(subscription().subscriptionId)}aksacr'

var azureWebAppName = '${uniqueString(subscription().subscriptionId)}-app'

var azureFunctionName ='${uniqueString(subscription().subscriptionId)}func'
var azureStorageAcountFunction = '${uniqueString(subscription().subscriptionId)}funcst'
var sqlServerName =  '${uniqueString(subscription().subscriptionId)}-sql'
var sqlDatabaseName = '${sqlServerName}/${sqlDbName}'
var applicationInsghtsName = 'func-appi'




// Creating resource group

// Deploy the resource group for the Azure Log Analytics.
resource log_rg 'Microsoft.Resources/resourceGroups@2021-01-01'={
  name: azurekLogAnalyticsRgName
  location: locationLogAnalytics
}

// Deploy the resource group for the Azure Function.
resource func_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployFunc){
  name: azureFunctionRgName
  location: locationAzureFunction
}

// Deploy the resource group for the Sql Database.
resource sql_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deploySql) {
  name: sqlRgName
  location: locationSqlDatabase
}

// Deploy the resource group for the Webapp.
resource app_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployApp) {
  name: azureWebAppRgName
  location: locationAzureFunction
}

// Deploy the resource group for the Azure Kubernetes Service.
resource aks_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployAks) {
  name: aksRgName
  location: locationAks
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

// Deploy the Azure Sql Server to host the database there.
module sql 'bicep-templates/sql.bicep' = if(deploySql) {
  name: 'sql'
  scope: sql_rg    
  params: {
    name: sqlServerName
    location:locationSqlDatabase
    SQL_Pass: SQL_Pass
    SQL_User: SQL_User
    projTagValue:projTagValue

  }
  }

// Deploy Azure Sql rule to enable the Azure resources to access the database.
  module sql_rule 'bicep-templates/sql-rule.bicep' = if(deploySql) {
    name: 'sql_rule'
    scope: sql_rg    
    params: {
      name: AzureSqlRuleName
      serverName:sqlServerName
      location:locationSqlDatabase
    }
    dependsOn:[
      sql
    ]
    }

// Deploy the Sql Database.
module sqldb 'bicep-templates/sqldb.bicep' = if(deploySql) {
name: 'sqldb'
scope: sql_rg    
params: {
  name: sqlDatabaseName
  location:locationSqlDatabase
  projTagValue:projTagValue
    logAnaliticName: logAnalyticName
  logAnaliticResourceGroup: azurekLogAnalyticsRgName
  skuName: sqlSkuName
  skuTier: sqlSkuTier
  skuCapacity: sqlSkuCapacity
  collation: sqlCollation
  catalogCollation: sqlCatalogCollation
}
dependsOn:[
  sql
]
}

// Deploy the Azure Kubernetes Cluster.
module aks 'bicep-templates/aks.bicep' = if(deployAks) {
  name: 'aks'
  scope: aks_rg    
  params: {
    name: aksName
    location:locationAks
    version: kubernetesVersion
    VmSize: aksVmSize
    projTagValue:projTagValue
    logAnalyticsName:logAnalyticName
    logAnaliticResourceGroup: azurekLogAnalyticsRgName
    workerNumber: aksNumberOfWorkers
  }
  dependsOn:[
    log

  ]
  }
  
  // Deploy the Azure Container Registry to store the docker images used inside the Aks.
  module aks_acr 'bicep-templates/aks-acr.bicep' = if(deployAks) {
    name: 'aks_acr'
    scope: aks_rg 
    params: {
      name: acrName
      location: locationAks
      aksName: aksName
      projTagValue:projTagValue
    }
    dependsOn:[
      aks
    ]
  }

  // Deploy the Azure Webapp.
  module app 'bicep-templates/app.bicep' = if(deployApp){
  name: 'app'
  scope: app_rg    
  params: {
    name: azureWebAppName
    location: locationWebApp
    planeName: azureServicePlanWebApp
    projTagValue:projTagValue
    logAnaliticName: logAnalyticName
    logAnaliticResourceGroup: azurekLogAnalyticsRgName
  }
  dependsOn:[
    app_plan
  ]
  }

  // Deploy the Service App Plan to host the Azure Webapp.
  module app_plan 'bicep-templates/plan.bicep' = if(deployApp){
    name: 'app_plan'
    scope: app_rg 
    params: {
      name: azureServicePlanWebApp
      location: locationWebApp
      sku:skuWebApp
      skuCode:skuCodeskuWebApp
      numberOfWorkers:numberOfWorkersWebApp
      projTagValue:projTagValue
    }
  }
  






