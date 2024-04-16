@minLength(1)
param nicIds array
@secure()
param adminPassword string
param location string = resourceGroup().location
param adminUsername string = 'testvmadmin'
param prefix string 


var vmName = '${prefix}-winVM'

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: 'computerName'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2012-R2-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [for id in nicIds: {
        id: id
      }]
    }  
  }
}

output vmId string = windowsVM.id
