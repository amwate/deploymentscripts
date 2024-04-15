param location string = resourceGroup().location
param prefix string = 'amwate'
param activeactive bool = true

var randomPrefix = '${prefix}-${uniqueString(resourceGroup().id)}'
var vngName = '${randomPrefix}-vng'

module pip '../modules/pip.bicep'  = {
  name : '${prefix}-pip'
  params:{
    location: location
    vmPipName: randomPrefix
  }
}

module vnet '../modules/vnet.bicep' = {
  name : '${prefix}-vnet'
  params:{
    location: location
    prefix : randomPrefix
  }
}

module vm '../modules/vm-nic.bicep' = {
  name : '${prefix}-winVM'
  params:{
    prefix: '${prefix}-winVM'
    subnetId: vnet.outputs.defaultSubnetId
    location: location
    prefix: randomPrefix
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
            id: pip.outputs.pipv4Id
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

