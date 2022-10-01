param sqlRgName string = 'sql-rg'
param sqlDbName string = 'sqldb'
@minLength(5)
param SQL_User string = 'omar1'
@minLength(5)
param SQL_Pass string = 'Kassar@14689'
param locationSqlDatabase string = 'East US'
param deploySql bool = true
var AzureSqlRuleName = 'AllowAllWindowsAzureIps'
var sqlServerName =  uniqueString(subscription().subscriptionId,'sql')
var sqlDatabaseName = '${sqlServerName}/${sqlDbName}'

param locationLogAnalytics string = 'East US'
param azurekLogAnalyticsRgName string = 'log-rg'
param logAnalyticName string = 'logAnaytics'



targetScope = 'subscription'

param projTagValue string = 'proj'

resource log_rg 'Microsoft.Resources/resourceGroups@2021-01-01'={
  name: azurekLogAnalyticsRgName
  location: locationLogAnalytics
}


resource sql_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = if(deploySql) {
  name: sqlRgName
  location: locationSqlDatabase
}

module sql 'bicep/sql.bicep' = if(deploySql) {
  name: 'sql'
  scope: sql_rg    // Deployed in the scope of resource group we created above
  params: {
    name: sqlServerName
    location:locationSqlDatabase
    SQL_Pass: SQL_Pass
    SQL_User: SQL_User
    projTagValue:projTagValue

  }
  }

  
module log 'bicep-templates/log.bicep' =  {
  name: logAnalyticName
  scope: log_rg
  params:{
    name: logAnalyticName
    location: locationLogAnalytics
    projTagValue:projTagValue
  }
}


  module sql_rule 'bicep/sql-rule.bicep' = if(deploySql) {
    name: 'sql_rule'
    scope: sql_rg    // Deployed in the scope of resource group we created above
    params: {
      name: AzureSqlRuleName
      serverName:sqlServerName
      location:locationSqlDatabase
    }
    dependsOn:[
      sql
    ]
    }

module sqldb 'bicep/sqldb.bicep' = if(deploySql) {
name: 'sqldb'
scope: sql_rg    // Deployed in the scope of resource group we created above
params: {
  name: sqlDatabaseName
  location:locationSqlDatabase
  projTagValue:projTagValue
  logAnaliticName: logAnalyticName
  logAnaliticResourceGroup: azurekLogAnalyticsRgName
}
dependsOn:[
  sql
]
}
