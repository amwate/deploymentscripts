param location string = resourceGroup().location
param activeactive bool = false
param num int = 2

module vngs 'vng.bicep' = [for i in range(0, num):{
  name: 'vng-${i}'
  params: {
    location: location 
    activeactive: activeactive
    prefix: 'vng-${i}'
    vnetAddressPrefix: [ '10.${i}.0.0/16', '2001:db8:abc${i}::/48' ]
    subnetAddressPrefix: [ '10.${i}.1.0/24', '2001:db8:abc${i}:11::/64' ]
    gatewaySubnetAddressPrefix: ['10.${i}.0.0/24', '2001:db8:abc${i}:12::/64']
  }
}]

// Create 2 Lngs
module lng 'lng.bicep' = [for i in range(0, num):{
  name: 'lng-${i}'
  params: {
    location: location
    ipAddress: vngs[i].outputs.pipArray[0]
    addressPrefixes: [ '10.${i}.1.0/24', '2001:db8:abc${i}:11::/64' ]
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
    localNetworkGatewayId: lng[num-1-i].outputs.localNetworkGatewayId
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
