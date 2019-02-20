$password = Read-Host -AsSecureString 'Please provide password for NGF, WAF and Web Server
!! BEWARE: Password complexity rules 12 characters, [A-Za-z0-9] and special char !!' 

Write-Host "`nCreating Resource Group $rg for the networking configuration"
New-AzureRMResourceGroup -Name $rg -Location "$location"

Write-Host "Deploying Barracuda Next Gen Firewall F Series"
New-AzureRMResourceGroupDeployment -Name "Deploy_$rg" -ResourceGroupName "$rg" `
    -TemplateFile "azuredeploy.json" -TemplateParameterFile "azuredeploy.parameters.json" `
    -adminPassword $password 
