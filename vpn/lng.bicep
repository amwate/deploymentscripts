// .bicep script to create a local network gateway
// https://docs.microsoft.com/en-us/azure/templates/microsoft.network/localnetworkgateways?tabs=bicep

param name string
param location string = resourceGroup().location
param ipAddress string
param addressPrefixes array

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2017-10-01' = {
  name: name
  location: location 
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: addressPrefixes
    }
    gatewayIpAddress: ipAddress
  }
}

output localNetworkGatewayId string = localNetworkGateway.id
output localNetworkGatewayName string = localNetworkGateway.name
