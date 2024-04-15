param subnetId string
param prefix string
param location string = resourceGroup().location

var nicName = '${prefix}-vmnic'
var vmName = '${prefix}-vmName'

module nic 'nic.bicep'= {
  name : nicName
  params:{
    backendSubnetId: subnetId
    resourceName: nicName
    location: location
    prefix: nicName
  }
}

module vm 'vm.bicep' = {
  name: vmName
  params:{
    location: location
    resourceName: vmName
    adminPassword: 'TestAdmin@12345'
    adminUsername: 'testvmadmin'
    nicIds:[
        resourceId('Microsoft.Network/networkInterfaces', nicName)
    ]
  }
  dependsOn:[
    nic
  ]
}

output vmId string = vm.name
output nicId string = resourceId('Microsoft.Network/networkInterfaces', nicName)
