param(
    [Parameter(Mandatory)]
    [ValidateSet("CBN", "CDM", "karna")] $environment, 
    [Parameter(Mandatory)]      $rgName,
    $prefix = "amwate", 
    [string] $templateParameterFile,
    [string] $templateFile
)

$filePath = ".\params\${environment}.json"
$values = Get-Content $filePath | ConvertFrom-json
$prefix = $values.prefix

$name =  "$prefix-$rgName"
$Location = $values.Location

Select-AzSubscription -Subscription $values.Subscription

if (-not( Get-AzResourceGroup -Name $name -ErrorAction Ignore)) {
      Write-Output "Creating resource group $name at $Location in $values.Subscription"
      $rg = New-AzResourceGroup -Name $name -Location $Location | Out-Null
}
else {
      Write-Output "Resource group $name is already present at $Location in $Subscription"
}
$rg = Get-AzResourceGroup -Name $name
$rg
print 'Created rg ${rg}.ResourceGroupName'

new-AzResourceGroupDeployment `
-ResourceGroup $rg.ResourceGroupName `
-TemplateFile $templateFile `
-AsJob | Format-List




