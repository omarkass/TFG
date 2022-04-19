targetScope = 'subscription'
param numberOfWorkers string = '1'
param deployThisResource bool = true

@description('SQL administrator user.')
@minLength(5)
param SQL_User string = 'omar1'

@description('SQL administrator user password.')
@minLength(5)
param SQL_Pass string = 'Kassar@14689'

@description('The version of Kubernetes.')
param kubernetesVersion string = '1.23.3'
param skuFunction string = 'Dynamic'
param skuCodeFunction string = 'Y1'

@description('Project prefix.')
param loactionAks string = 'East US'
param subscriptionId string = 'b5621309-22cd-4fc5-930c-dabc2c4c9ae7'

@description('Project prefix.')
param loactionAzureFunction string = 'East US'

@description('Project prefix.')
param loactionSqlDatabase string = 'East US'

@description('Project prefix.')
param loactionWebApp string = 'East US'

var proj = 'proj'
var env = 'dev'
var aksName = '${proj}-${env}-aks'
var aksRgName = '${proj}-${env}-aks-rg'
var azureWebAppRgName = '${proj}-${env}-app-rg'
var azureServicePlanWebApp = '${proj}-${env}-app-plan'
var azureWebAppName = '${proj}-${env}-app'
var azureFunctionRgName = '${proj}-${env}-func-rg'
var azureFunctionName = '${proj}-${env}-func'
var azureServicePlanFunction = '${proj}-${env}-func-plan'
var azureStorageAcountFunction = '${proj}${env}funcst55'
var sqlServerName = '${proj}-${env}-sql'
var sqlDatabaseName = '${sqlServerName}/${proj}-${env}-sqldb'
var sqlRgName = '${proj}-${env}-sql-rg'
// Creating resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: azureFunctionRgName
  location: loactionAzureFunction
}

// Deploying storage account using module
module stg './bicep-templates/storage.bicep' = {
  name: 'storageDeployment'
  scope: rg    // Deployed in the scope of resource group we created above
  params: {
    storageAccountName: azureStorageAcountFunction
  }
}
