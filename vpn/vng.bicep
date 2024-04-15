param location string = resourceGroup().location
param prefix string = 'amwate'
param activeactive bool = true
param deployVM bool = true

var randomPrefix = '${prefix}-${uniqueString(resourceGroup().id)}'
var vnetName = '${randomPrefix}-vnet'
var vmName = '${randomPrefix}-winVM'
var pipName = '${randomPrefix}-pip'
var vngName = '${randomPrefix}-vng'
var ipConfigName = '${randomPrefix}-ipConfig'

module vnet '../modules/vnet.bicep' = {
  name : vnetName 
  params:{
    location: location
    prefix : randomPrefix
  }
}

module vm '../modules/vm-nic.bicep' = if (deployVM) {
  name : vmName 
  params:{
    prefix: vmName 
    subnetId: vnet.outputs.defaultSubnetId
    location: location
  }
  dependsOn:[
    vnet
  ]
}

var numberOfPips = activeactive ? 2 : 1
module pip '../modules/pip.bicep' = [for i in range(0, numberOfPips):{
  name : '${pipName}-${i}'
  params:{
    location: location
    vmPipName: '${pipName}-${i}'
  }
}]


resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name : vngName 
  location: location

  properties: {
    ipConfigurations :  [ for i in range(0,numberOfPips):{
        name: ipConfigName 
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnet.outputs.gatewaySubnetId
          }

          publicIPAddress: {
            id : pip[i].outputs.vmPipId
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
    activeActive: activeactive

    bgpSettings: {
      asn : 65010
      bgpPeeringAddress: '60.10.1.5,60.10.1.4'
    }
  }

  dependsOn:[
    pip
    vnet
  ]
}
output pipIdArray array = [for i in range(0,numberOfPips):pip[i].outputs.vmPipId] 
output vngId string = virtualNetworkGateway.id
output pipArray array = [for i in range(0,numberOfPips):pip[i].outputs.vmPipIp]
