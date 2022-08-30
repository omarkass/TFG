targetScope = 'subscription'
//parameters 
//sql parameters 
@minLength(5)
param SQL_User string = 'omar1'
@minLength(5)
param SQL_Pass string = 'Kassar@14689'
param locationSqlDatabase string = 'East US'

// kubernetes parameters
param locationAks string = 'Korea Central'
param numberOfWorkers string = '1'
param kubernetesVersion string = '1.22.11'
param aksVmSize string = 'standard_b2s'

//function parameters 
param skuFunction string = 'Dynamic'
param skuCodeFunction string = 'Y1'
param locationAzureFunction string = 'East US'
param numberOfWorkersFunction string = '1'


//webapp parameters
param locationWebApp string = 'East US'
param skuWebApp string = 'Free'
param skuCodeskuWebApp string = 'F1'
param numberOfWorkersWebApp string = '1'

param proj string = 'proj'
param env string = 'dev'

param deployAks bool = true
param deployFunc bool = true
param deployApp bool = true
param deploySql bool = true

var AzureSqlRuleName = 'AllowAllWindowsAzureIps'
var aksName = '${proj}-${env}-aks'
var acrName = uniqueString(subscription().subscriptionId,proj,env,'acr','aks')
var aksRgName = '${proj}-${env}-aks-rg'
var azureWebAppRgName = '${proj}-${env}-app-rg'
var azureServicePlanWebApp = '${proj}-${env}-app-plan'
var azureWebAppName = uniqueString(subscription().subscriptionId,proj,env,'app')
var azureFunctionRgName = '${proj}-${env}-func-rg'
var azureFunctionName =uniqueString(subscription().subscriptionId,proj,env,'func')
var azureServicePlanFunction = '${proj}-${env}-func-plan'
var azureStorageAcountFunction = uniqueString(subscription().subscriptionId,proj,env,'func','st')
var sqlServerName =  uniqueString(subscription().subscriptionId,proj,env,'sql')
var sqlDatabaseName = '${sqlServerName}/${proj}-${env}-sqldb'
var sqlRgName = '${proj}-${env}-sql-rg'
var logAnalyticName = '${proj}-${env}-func-log'
var applicationInsghtsName = '${proj}-${env}-func-appi'
var projTagValue = 'proj'



// Creating resource group
resource func_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployFunc){
  name: azureFunctionRgName
  location: locationAzureFunction
}
resource sql_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deploySql) {
  name: sqlRgName
  location: locationSqlDatabase
}
resource app_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployApp) {
  name: azureWebAppRgName
  location: locationAzureFunction
}
resource aks_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deployAks) {
  name: aksRgName
  location: locationAks
}


// Deploying storage account using module
module func_st './bicep-templates/func-st.bicep' = if(deployFunc) {
  name: 'func_st'
  scope: func_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureStorageAcountFunction
    location:locationAzureFunction
    projTagValue:projTagValue
  }
}

module func_plan './bicep-templates/plan.bicep' = if(deployFunc)  {
  name: 'func_plan'
  scope: func_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureServicePlanFunction
    location:locationAzureFunction
    sku: skuFunction
    skuCode: skuCodeFunction
    numberOfWorkers : numberOfWorkersFunction
    projTagValue:projTagValue
  }
}

module func_log 'bicep-templates/func-log.bicep' = if(deployFunc) {
  name: logAnalyticName
  scope: func_rg
  params:{
    name: logAnalyticName
    location: locationAzureFunction
    projTagValue:projTagValue
  }
}

module func_appi 'bicep-templates/func-appi.bicep' = if(deployFunc) {
  name : 'func_appi'
  scope: func_rg 
  params:{
    name: applicationInsghtsName
    location: locationAzureFunction
    logAnaliticName: logAnalyticName
    azureFunctionName: azureFunctionName
    projTagValue:projTagValue
  }
  dependsOn:[
    func_log
  ]
}

module func 'bicep-templates/func.bicep' = if(deployFunc) {
  name: 'func'
  scope: func_rg    // Deployed in the scope of resource group we created above
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

module sqldb 'bicep-templates/sqldb.bicep' = if(deploySql) {
  name: 'sqdbl'
  scope: sql_rg    // Deployed in the scope of resource group we created above
  params: {
    name: sqlServerName
    location:locationSqlDatabase
    SQL_Pass: SQL_Pass
    SQL_User: SQL_User
    projTagValue:projTagValue
  }
  }


  module sql_rule 'bicep-templates/sql-rule.bicep' = if(deploySql) {
    name: 'sql_rule'
    scope: sql_rg    // Deployed in the scope of resource group we created above
    params: {
      name: AzureSqlRuleName
      serverName:sqlServerName
      location:locationSqlDatabase
    }
    dependsOn:[
      sqldb
    ]
    }

module sql 'bicep-templates/sql.bicep' = if(deploySql) {
name: 'sql'
scope: sql_rg    // Deployed in the scope of resource group we created above
params: {
  name: sqlDatabaseName
  location:locationSqlDatabase
  projTagValue:projTagValue
}
dependsOn:[
  sqldb
]
}


module aks 'bicep-templates/aks.bicep' = if(deployAks) {
  name: 'aks'
  scope: aks_rg    // Deployed in the scope of resource group we created above
  params: {
    name: aksName
    location:locationAks
    version: kubernetesVersion
    VmSize: aksVmSize
    projTagValue:projTagValue
  }
  }
  
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


  module app 'bicep-templates/app.bicep' = if(deployApp){
  name: 'app'
  scope: app_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureWebAppName
    location: locationWebApp
    planeName: azureServicePlanWebApp
    projTagValue:projTagValue
  }
  dependsOn:[
    app_plan
  ]
  }

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
  




/*
 name: 'func_plan'
  scope: func_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureServicePlanFunction
    location:locationAzureFunction
    skuFunction: skuFunction
    skuCodeFunction: skuCodeFunction
    numberOfWorkers : numberOfWorkers


*/


