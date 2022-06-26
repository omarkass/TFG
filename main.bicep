targetScope = 'subscription'
//parameters 
//sql parameters 
@minLength(5)
param SQL_User string = 'omar1'
@minLength(5)
param SQL_Pass string = 'Kassar@14689'
param locationSqlDatabase string = 'East US'

// kubernetes parameters
param locationAks string = 'West Europe'
param numberOfWorkers string = '1'
param kubernetesVersion string = '1.23.3'

//function parameters 
param skuFunction string = 'Dynamic'
param skuCodeFunction string = 'Y1'
param locationAzureFunction string = 'East US'


//webapp parameters
param locationWebApp string = 'East US'

param proj string = 'proj'
param env string = 'dev'

var AzureSqlRuleName = 'AllowAllWindowsAzureIps'
var aksName = '${proj}-${env}-aks'
var acrName = '${proj}${env}aksacr'
var aksRgName = '${proj}-${env}-aks-rg'
var azureWebAppRgName = '${proj}-${env}-app-rg'
var azureServicePlanWebApp = '${proj}-${env}-app-plan'
var azureWebAppName = '${proj}-${env}-app'
var azureFunctionRgName = '${proj}-${env}-func-rg'
var azureFunctionName = '${proj}-${env}-func'
var azureServicePlanFunction = '${proj}-${env}-func-plan'
var azureStorageAcountFunction = uniqueString(subscription().subscriptionId,proj,env,'func','st')//'${proj}${env}funcst55'
var sqlServerName = '${proj}-${env}-sql'
var sqlDatabaseName = '${sqlServerName}/${proj}-${env}-sqldb'
var sqlRgName = '${proj}-${env}-sql-rg'
var logAnalyticName = '${proj}-${env}-func-log'
var applicationInsghtsName = '${proj}-${env}-func-appi'



// Creating resource group
resource func_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: azureFunctionRgName
  location: locationAzureFunction
}
resource sql_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: sqlRgName
  location: locationSqlDatabase
}
resource app_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: azureWebAppRgName
  location: locationAzureFunction
}
resource aks_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: aksRgName
  location: locationAks
}


// Deploying storage account using module
module func_st './bicep-templates/func-st.bicep' = {
  name: 'func_st'
  scope: func_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureStorageAcountFunction
    location:locationAzureFunction
  }
}

module func_plan './bicep-templates/func-plan.bicep' = {
  name: 'func_plan'
  scope: func_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureServicePlanFunction
    location:locationAzureFunction
    skuFunction: skuFunction
    skuCodeFunction: skuCodeFunction
    numberOfWorkers : numberOfWorkers
  }
}

module func_log 'bicep-templates/func-log.bicep' = {
  name: logAnalyticName
  scope: func_rg
  params:{
    name: logAnalyticName
    location: locationAzureFunction
  }
}

module func_appi 'bicep-templates/func-appi.bicep' = {
  name : 'func_appi'
  scope: func_rg 
  params:{
    name: applicationInsghtsName
    location: locationAzureFunction
    logAnaliticName: logAnalyticName
    azureFunctionName: azureFunctionName
  }
  dependsOn:[
    func_log
  ]
}

module func 'bicep-templates/func.bicep' = {
  name: 'func'
  scope: func_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureFunctionName
    location:locationAzureFunction
    planName: azureServicePlanFunction
    StorageAcountName: azureStorageAcountFunction
    applicationInsightName:applicationInsghtsName
  }
  dependsOn:[
    func_plan
    func_appi
  ]
}

module sqldb 'bicep-templates/sqldb.bicep' = {
  name: 'sqdbl'
  scope: sql_rg    // Deployed in the scope of resource group we created above
  params: {
    name: sqlServerName
    location:locationSqlDatabase
    SQL_Pass: SQL_Pass
    SQL_User: SQL_User
  }
  dependsOn:[
    sql
  ]
  }


  module sql_rule 'bicep-templates/sql-rule.bicep' = {
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

module sql 'bicep-templates/sql.bicep' = {
name: 'sql'
scope: sql_rg    // Deployed in the scope of resource group we created above
params: {
  name: sqlDatabaseName
  location:locationSqlDatabase
}
}

module aks 'bicep-templates/aks.bicep' = {
  name: 'aks'
  scope: aks_rg    // Deployed in the scope of resource group we created above
  params: {
    name: aksName
    location:locationAks
    version: kubernetesVersion
  }
  }
  

  module app 'bicep-templates/app.bicep' = {
  name: 'app'
  scope: app_rg    // Deployed in the scope of resource group we created above
  params: {
    name: azureWebAppName
    location: locationWebApp
    planeName: azureServicePlanWebApp
  }
  dependsOn:[
    app_plan
  ]
  }

  module app_plan 'bicep-templates/app-plan.bicep' = {
    name: 'app_plan'
    scope: app_rg 
    params: {
      name: azureServicePlanWebApp
      location: locationWebApp
    }
  }
  

  module aks_acr 'bicep-templates/aks-acr.bicep' = {
    name: 'aks_acr'
    scope: aks_rg 
    params: {
      name: acrName
      location: locationAks
      aksName: aksName
    }
    dependsOn:[
      aks
    ]
  }
