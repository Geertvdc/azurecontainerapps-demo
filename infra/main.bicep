param appName string = 'globotickets'
param location string = resourceGroup().location

param frontendImage string
param catalogImage string
param orderingImage string
param containerRegistry string
param containerRegistryUsername string

@secure()
param containerRegistryPassword string = ''

var registryPasswordSecret = 'registry-password'

module environment 'containerApp-environment.bicep' = {
  name: '${deployment().name}-environment'
  params: {
    environmentName: appName
    location: location
    appInsightsName: '${appName}-ai'
    logAnalyticsWorkspaceName: '${appName}-la'
  }
}

module frontend 'containerApp-app.bicep' = {
  name: '${deployment().name}-frontendApp'
  params: {
    containerAppName: '${appName}-frontend'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: true
    image: frontendImage
    containerRegistry: containerRegistry
    registryPassword: registryPasswordSecret
    containerRegistryUsername: containerRegistryUsername
    secrets: [
      {
        name: registryPasswordSecret
        value: containerRegistryPassword
      }
    ]
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'ApiConfigs__ConcertCatalog__Uri'
        value: catalog.outputs.url
      }
      {
        name: 'ApiConfigs__Ordering__Uri'
        value: ordering.outputs.url
      }
    ]
  }
}

module catalog 'containerApp-app.bicep' = {
  name: '${deployment().name}-catalogApp'
  params: {
    containerAppName: '${appName}-catalog'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: false
    image: catalogImage
    containerRegistry: containerRegistry
    registryPassword: registryPasswordSecret
    containerRegistryUsername: containerRegistryUsername
    secrets: [
      {
        name: registryPasswordSecret
        value: containerRegistryPassword
      }
    ]
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
    ]
  }
}

module ordering 'containerApp-app.bicep' = {
  name: '${deployment().name}-orderingApp'
  params: {
    containerAppName: '${appName}-ordering'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: false
    image: orderingImage
    containerRegistry: containerRegistry
    registryPassword: registryPasswordSecret
    containerRegistryUsername: containerRegistryUsername
    secrets: [
      {
        name: registryPasswordSecret
        value: containerRegistryPassword
      }
    ]
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
    ]
  }
}

module cosmosdb 'cosmos.bicep' = {
  name: '${appName}-cosmosdb'
  params: {
    accountName: '${appName}-cosmos'
    location: location
    primaryRegion: location
  }
}

module pubsub 'pubsub.bicep' =  {
  name: '${appName}-bus'
  params: {
    busName: '${appName}Bus'
    location: location
  }
}

resource shopstateComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: '${appName}/shopstate'
  dependsOn: [
    environment
  ]
  properties: {
    componentType: 'state.azure.cosmosdb'
    version: 'v1'
    secrets: [
      {
        name: 'masterkey'
        value: cosmosdb.outputs.primaryMasterKey
      }
    ]
    metadata: [
      {
        name: 'url'
        value: cosmosdb.outputs.documentEndpoint
      }
      {
        name: 'database'
        value: 'basketDb'
      }
      {
        name: 'collection'
        value: 'baskets'
      }
      {
        name: 'masterkey'
        value: cosmosdb.outputs.primaryMasterKey
      }
    ]
  }
}

