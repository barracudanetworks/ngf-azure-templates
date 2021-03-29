#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a specific ARM template
.EXAMPLE
    Invoke-Pester 
.NOTES
    This file has been created as an example of using Pester to evaluate ARM templates
#>

Function random-password ($length = 15)
{
    $punc = 46..46
    $digits = 48..57
    $letters = 65..90 + 97..122

    # Thanks to
    # https://blogs.technet.com/b/heyscriptingguy/archive/2012/01/07/use-pow
    $password = get-random -count $length `
        -input ($punc + $digits + $letters) |
            % -begin { $aa = $null } `
            -process {$aa += [char]$_} `
            -end {$aa}

    return $password
}

$templateName = "CGF-LogAnalytics-Dashboard"
$sourcePath = "$env:BUILD_SOURCESDIRECTORY\$templateName"
$scriptPath = "$env:BUILD_SOURCESDIRECTORY\$templateName\test"
$templateFileName = "azuredeploy.json"
$templateFileLocation = "$sourcePath\$templateFileName"
$templateMetadataFileName = "metadata.json"
$templateMetadataFileLocation = "$sourcePath\$templateMetadataFileName"
$templateParameterFileName = "azuredeploy.parameters.json"
$templateParameterFileLocation = "$sourcePath\$templateParameterFileName" 

Describe "[$templateName] Template validation & test" {
    
    Context "[$templateName] Template validation" {
        
        It 'Has a JSON template' {        
            $templateFileLocation | Should Exist
        }
        
        It 'Has a parameters file' {        
            $templateParameterFileLocation | Should Exist
        }
		
        It 'Has a metadata file' {        
            $templateMetadataFileLocation | Should Exist
        }

        It 'Converts from JSON and has the expected properties' {
            $expectedProperties = '$schema',
                                  'contentVersion',
								  'outputs',
                                  'parameters',
                                  'resources',                                
                                  'variables'
            $templateProperties = (get-content $templateFileLocation | ConvertFrom-Json -ErrorAction SilentlyContinue) | Get-Member -MemberType NoteProperty | % Name
            $templateProperties | Should Be $expectedProperties
        }
        
        It 'Creates the expected Azure resources' {
            $expectedResources = 'Microsoft.OperationalInsights/workspaces',
                                 'Microsoft.OperationalInsights/workspaces/savedSearches',
                                 'Microsoft.OperationalInsights/workspaces/savedSearches',
                                 'Microsoft.OperationalInsights/workspaces/views',
                                 'Microsoft.OperationalInsights/workspaces/views',
                                 'Microsoft.OperationalInsights/workspaces/views',
                                 'Microsoft.OperationalInsights/workspaces/views',
                                 'Microsoft.OperationsManagement/solutions',
                                 'Microsoft.OperationsManagement/solutions',
                                 'Microsoft.OperationsManagement/solutions',
                                 'Microsoft.OperationsManagement/solutions',
                                 'Microsoft.Resources/deployments'
            $templateResources = (get-content $templateFileLocation | ConvertFrom-Json -ErrorAction SilentlyContinue).Resources.type
            $templateResources | Should Be $expectedResources
        }
        
        It 'Contains the expected parameters' {
            $expectedTemplateParameters = 'neworExisting',
                                            'type',
                                            'workspaceName'
                                            
            $templateParameters = (get-content $templateFileLocation | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters | Get-Member -MemberType NoteProperty | % Name
            $templateParameters | Should Be $expectedTemplateParameters
        }

    }

    Context  "[$templateName] Template test deployment" {

        # Basic Variables
        $testsRandom = Get-Random 10001
        $testsPrefix = "CUDAQA$testsRandom"
        $testsResourceGroupName = "CUDAQA-$testsRandom-$templateName"
       # $testsAdminPassword = $testsResourceGroupName | ConvertTo-SecureString -AsPlainText -Force
        $workspace = "$testsPrefix-CGFtest"
        $testsResourceGroupLocation = "East US2"

        # List of all scripts + parameter files
        $testsTemplateList=@()
        ## dummy parameter file to test default parameters
        $testsTemplateList += ,@("azuredeploy.json","azuredeploy.parameters.json")

        # Set working directory & create resource group
        Set-Location $sourcePath
        New-AzResourceGroup -Name $testsResourceGroupName -Location "$testsResourceGroupLocation"

        # Validate all ARM templates one by one
        $testsErrorFound = $false

        It "Test Deployment of ARM template $testsTemplateFile with parameter file $testsTemplateParemeterFile" {
            (Test-AzResourceGroupDeployment -ResourceGroupName $testsResourceGroupName -TemplateFile "azuredeploy.json" -TemplateParameterFile "azuredeploy.parameters.json" -workspaceName "$workspace" ).Count | Should not BeGreaterThan 0
        }
        It "Deployment of ARM template $testsTemplateFile with parameter file $testsTemplateParemeterFile" {
            $resultDeployment = New-AzResourceGroupDeployment -ResourceGroupName $testsResourceGroupName -TemplateFile $templateFileLocation -TemplateParameterFile $templateParameterFileLocation -workspaceName "$workspace"
            Write-Host ($resultDeployment | Format-Table | Out-String)
            Write-Host $resultDeployment.ProvisioningState
            $resultDeployment.ProvisioningState | Should Be "Succeeded"
        }
        It "Deployment in Azure validation" {
            $result = Get-AzResource -ResourceGroupName "$testsResourceGroupName" | Where-Object { $_.Name -like "$testsPrefix*" } 
            Write-Host ($result | Format-Table | Out-String)
            $result | Should Not Be $null
        }
        Write-Host "Removing resourcegroup $testsResourceGroupName"
        Remove-AzResourceGroup -Name $testsResourceGroupName -Force

    }

}