param location string = resourceGroup().location
param activeactive bool = false
param num int = 2

module vngs 'vng.bicep' = [for i in range(0, num):{
  name: 'vng-${i}'
  params: {
    location: location 
    activeactive: activeactive
    prefix: 'vng-${i}'
  }
}
]

// Create 2 Lngs
module lng 'lng.bicep' = [for i in range(0, num):{
  name: 'lng-${i}'
  params: {
    location: location
    ipAddress: vngs[i].outputs.pipArray[0]
    addressPrefixes: [ '10.1.1.0/24', 'ace:bde::/64' ]
    name: 'lng-${i}'
  }

  dependsOn: [
  vngs
 ]
}
]

module connections 'connection.bicep' = [for i in range(0, num):{
  name: 'connection-${i}'
  params: {
    connectionType: 'IPsec'
    location: location
    virtualNetworkGatewayId: vngs[i].outputs.vngId
    localNetworkGatewayId: lng[i].outputs.localNetworkGatewayId
    connectionName: 'connection-${i}'
  }

  dependsOn: [
    vngs
    lng
  ]
}
]

output vngIds array = [for i in range(0, num): vngs[i].outputs.vngId]
output pipIds array = [for i in range(0, num): vngs[i].outputs.pipIdArray]
output lngIds array = [for i in range(0, num): lng[i].outputs.localNetworkGatewayId]
output connectionIds array = [for i in range(0, num): connections[i].outputs.connectionId]
