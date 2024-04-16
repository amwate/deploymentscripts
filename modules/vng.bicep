param location string = resourceGroup().location
param prefix string = 'amwate'
param activeactive bool = true

var randomPrefix = '${prefix}-${uniqueString(resourceGroup().id)}'
var vngName = '${randomPrefix}-vng'
var vmName = '${randomPrefix}-winVM'
var vnetName = '${randomPrefix}-vnet'

module pip '../modules/pip.bicep'  = {
  name : '${prefix}-pip'
  params:{
    location: location
    prefix: randomPrefix
  }
}

module vnet '../modules/vnet.bicep' = {
  name : vnetName 
  params:{
    location: location
    prefix : randomPrefix
  }
}

module vm '../modules/vm-nic.bicep' = {
  name : vmName 
  params:{
    prefix: randomPrefix
    subnetId: vnet.outputs.defaultSubnetId
    location: location
  }

  dependsOn:[
    vnet
  ]
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name : vngName
  location: location
  properties: {
    ipConfigurations :  [
      {
        name: '${vngName}-ipConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnet.outputs.gatewaySubnetId
          }
          publicIPAddress: {
            id: pip.outputs.vmPipId
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw2'
      tier: 'VpnGw2'
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
output vngName string = virtualNetworkGateway.name
output vngId string = virtualNetworkGateway.id
