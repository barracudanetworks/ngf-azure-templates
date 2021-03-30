Write-Host "
##############################################################################################################
  ____                                      _       
 | __ )  __ _ _ __ _ __ __ _  ___ _   _  __| | __ _ 
 |  _ \ / _` | '__| '__/ _` |/ __| | | |/ _` |/ _` |
 | |_) | (_| | |  | | | (_| | (__| |_| | (_| | (_| |
 |____/ \__,_|_|  |_|  \__,_|\___|\__,_|\__,_|\__,_|
                                                    
 Script to deploy the Barracuda CloudGen Firewall into existing Microsoft Azure infrastructure.

##############################################################################################################

"

$location = "West Europe"
$prefix="CUDA"
$rg="$prefix-RG"

$password = Read-Host -AsSecureString 'Please provide password for NGF
!! BEWARE: Password complexity rules 12 characters, [A-Za-z0-9] and special char !!' 

Write-Host "`nCreating Resource Group $rg"
New-AzureRMResourceGroup -Name $rg -Location "$location"

Write-Host "`nDeployment of $rg resources ..."
New-AzureRMResourceGroupDeployment -Name "Deploy_$rg" -ResourceGroupName "$rg" `
    -TemplateFile "azuredeploy.json" -TemplateParameterFile "azuredeploy.parameters.json" `
    -adminPassword $password -prefix $prefix
