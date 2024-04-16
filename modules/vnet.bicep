param location string = resourceGroup().location
param prefix string = uniqueString(resourceGroup().id)

var vnetName = '${prefix}-vnet'
param gatewaySubnetPrefixes array = [
  '10.0.0.0/24'
  '2001:db8:abcd:11::/64'
]
param vnetPrefixes array = [
  '10.0.0.0/16'
  '2001:db8:abcd::/48'
]
param defaultSubnetPrefixes array = [
  '10.0.1.0/24'
  '2001:db8:abcd:12::/64'
]

var defaultSubnetName = 'default'
var gatewaySubnetName = 'GatewaySubnet'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetPrefixes
    }
    subnets: [
      {
        name: defaultSubnetName
        properties: {
          addressPrefixes: defaultSubnetPrefixes
        }
      }
      {
        name: gatewaySubnetName
        properties: {
          addressPrefixes: gatewaySubnetPrefixes
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output id string = vnet.id
output defaultSubnetId string = vnet.properties.subnets[0].id
output gatewaySubnetId string = vnet.properties.subnets[1].id
