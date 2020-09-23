# Prerequisites
#   1. Create app registrations for APIM OAuth2 authentication, as described on https://bit.ly/api-management-oauth-aad

# What we will be doing in this script.
#   1. Retrieve app registrations
#   2. Create a resource group
#   3. Deploy Azure services

# Update these according to the environment
$subscriptionName = "Visual Studio Enterprise"
$apiAppRegistrationName = "api-app-registration-api-platform-security"
$resourceGroupName = "rg-rg-api-platform-security-2"
$appServiceName = "app-api-platform-security-2"
$basePath = "C:\Users\elder\OneDrive\Sessions\Building-better-security-for-your-API-platform-using-Azure-API-Management"
$settingsPath = "$basePath\.vscode\settings.json"
$administratorEmail = "me@eldert.net"

# Retrieves the dynamic parameters
$administratorObjectId = (Get-AzADUser -Mail $administratorEmail).Id
$basicAuthenticationPassword = (Get-Content -Path $settingsPath | ConvertFrom-Json).'rest-client.environmentVariables'.'$shared'.basicAuthenticationPassword

# Login to Azure
Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

# Retrieve application registration for the API
$apiAppRegistration = Get-AzADApplication -DisplayName $apiAppRegistrationName

# Create the resource group and deploy the resources
New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Building better security for your API platform using Azure API Management"; Purpose="Session"}
New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\Assets\Code\IaC\azuredeploy.json" -administratorObjectId $administratorObjectId -basicAuthenticationPassword $basicAuthenticationPassword -apiAppRegistrationApplicationId $apiAppRegistration.ApplicationId

# Deploy contents of the App Service
dotnet publish -c Release -o "$basePath\Assets\Code\Web API\AssetManagementApi\publish"
Compress-Archive -Path "$basePath\Assets\Code\Web API\AssetManagementApi\publish\*" -DestinationPath "$basePath\Assets\Code\Web API\AssetManagementApi\Deployment.zip"
Publish-AzWebapp -ResourceGroupName $resourceGroupName -Name $appServiceName -ArchivePath "$basePath\Assets\Code\Web API\AssetManagementApi\Deployment.zip"
Remove-Item "$basePath\Assets\Code\Web API\AssetManagementApi\Deployment.zip"

# Optional for debugging, loops through each local file individually
#Get-ChildItem "$basePath\Assets\Code\IaC" -Filter *.json | 
#Foreach-Object {
#    Write-Output "Deploying: " $_.FullName
#    New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile $_.FullName -ErrorAction Ignore
#}