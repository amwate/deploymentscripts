param backendSubnetId string
param resourceName string
param location string = resourceGroup().location
param prefix string = uniqueString(resourceGroup().id)

var ipconfName = '${resourceName}-ipconfig'
var pipName = '${prefix}-vmpip'
var nicName = '${prefix}-vmnic'

module pip '../modules/pip.bicep' = {
  name : pipName
  params:{
    location: location
    vmPipName : 'vmpip-${uniqueString(resourceName)}'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: ipconfName
        properties: {
          subnet: {
            id: backendSubnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id:pip.outputs.vmPipId
          }
        }
      }
      {
        name : '${ipconfName}-v6'
        properties:{
          privateIPAddressVersion:'IPv6'
          privateIPAllocationMethod:'Dynamic'
          subnet:{
            id:backendSubnetId
          }
        }
      }
    ]
  }
  dependsOn:[
    pip
  ]
}

output id string = nic.id
