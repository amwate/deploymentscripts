param location string = resourceGroup().location
param vmPipName string


resource pip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: vmPipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion:'IPv4'
    publicIPAllocationMethod:'Static'
    idleTimeoutInMinutes: 4
    dnsSettings:{
      domainNameLabel:vmPipName
      fqdn: '${vmPipName}.${toLower(location)}.cloudapp.azure.com'
    }
  }
}

output vmPipId string = pip.id
output vmPipFqdn string = pip.properties.dnsSettings.fqdn
output vmPipIp string = pip.properties.ipAddress
