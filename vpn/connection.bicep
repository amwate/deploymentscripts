param location string = resourceGroup().location
param connectionType string = 'IPsec'
param virtualNetworkGatewayId string
param enableBgp bool = false
param sharedKey string = uniqueString(resourceGroup().id)
param localNetworkGatewayId string
param connectionName string
param prefix string = 'amwate'

var randomName = '${prefix}-${connectionName}-${uniqueString(resourceGroup().id)}'

resource connectionName_resource 'Microsoft.Network/connections@2021-02-01' = {
  name: randomName 
  location: location
  properties: {
    connectionType:  connectionType    
    virtualNetworkGateway1: {
      id: virtualNetworkGatewayId
      properties: {
        
      }
    }
    enableBgp: enableBgp
    sharedKey: sharedKey
    localNetworkGateway2: {
      id: localNetworkGatewayId
      properties: {
        
      }
    }
  }
  dependsOn: []
}

output connectionId string = connectionName_resource.id
