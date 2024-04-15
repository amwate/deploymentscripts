# deploymentscripts
Deployment scripts in bicep to deploy the VPN GW
Sample Usage for deployment 
\deploy.ps1 -environment CBN -rgname $rgName -templateFile .\vpn\crossconnect.bicep

The above command creates a new Resource Group and deploys the resources in the same. 

Use Get-Job (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-job?view=powershell-7.4) to retrieve the running jobs 

and use Receive-Job (One time) to see the output generated by a given job. (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/receive-job?view=powershell-7.4)

