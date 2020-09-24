# Prerequisites
#   1. Create app registrations for APIM OAuth2 authentication, as described on https://bit.ly/api-management-oauth-aad

# What we will be doing in this script.
#   1. Retrieve app registrations
#   2. Create a resource group
#   3. Deploy Azure services

# Update these according to the environment
$subscriptionName = "Visual Studio Enterprise"
$apiAppRegistrationName = "api-app-registration-api-platform-security"
$resourceGroupName = "rg-api-platform-security"
$basePath = "C:\Users\elder\OneDrive\Sessions\Building-better-security-for-your-API-platform-using-Azure-API-Management"
$settingsPath = "$basePath\.vscode\settings.json"
$administratorEmail = "me@eldert.net"

# Login to Azure
Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

# Retrieves the dynamic parameters
$administratorObjectId = (Get-AzADUser -Mail $administratorEmail).Id
$basicAuthenticationPassword = (Get-Content -Path $settingsPath | ConvertFrom-Json).'rest-client.environmentVariables'.'$shared'.basicAuthenticationPassword | ConvertTo-SecureString -AsPlainText -Force
$apiAppRegistration = Get-AzADApplication -DisplayName $apiAppRegistrationName | ConvertTo-SecureString -AsPlainText -Force

# Create the resource group and deploy the resources
New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Building better security for your API platform using Azure API Management"; Purpose="Session"}
New-AzResourceGroupDeployment -Name "APISecurity" -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\assets\code\iac\azuredeploy.json" -administratorObjectId $administratorObjectId -basicAuthenticationPassword $basicAuthenticationPassword -apiAppRegistrationApplicationId $apiAppRegistration.ApplicationId

# Deploy contents of the App Service
dotnet publish "$basePath\assets\code\web-api\asset-management-api\AssetManagementApi.csproj" -c Release -o "$basePath\assets\code\web-api\asset-management-api\publish"
Compress-Archive -Path "$basePath\assets\code\web-api\asset-management-api\publish\*" -DestinationPath "$basePath\assets\code\web-api\asset-management-api\Deployment.zip"
Publish-AzWebapp -ResourceGroupName $resourceGroupName -ArchivePath "$basePath\assets\code\web-api\asset-management-api\Deployment.zip"
Remove-Item "$basePath\assets\code\web-api\asset-management-api\Deployment.zip"

# Optional for debugging, loops through each local file individually
#Get-ChildItem "$basePath\assets\code\iac" -Filter *.json | 
#Foreach-Object {
#    Write-Output "Deploying: " $_.FullName
#   New-AzResourceGroupDeployment -Name "APISecurity" -ResourceGroupName $resourceGroupName -TemplateFile $_.FullName -ErrorAction Continue
#}