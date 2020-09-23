# What we will be doing in this script.
#   1. Create a app registration for the API, if not exists
#   2. Create a app registration for the consumer, if not exists
#   3. Create a resource group
#   4. Deploy Azure services

# Update these according to the environment
$subscriptionName = "Visual Studio Enterprise"
$apiAppRegistrationName = "api-app-registration-api-platform-security"
$clientAppRegistrationName = "client-app-registration-api-platform-security"
$apiManagementInstanceName = "apim-api-platform-security-3"
$resourceGroupName = "rg-rg-api-platform-security-2"
$basePath = "C:\Users\elder\OneDrive\Sessions\Building-better-security-for-your-API-platform-using-Azure-API-Management"
$settingsPath = "$basePath\.vscode\settings.json"
$administratorEmail = "me@eldert.net"

# Retrieves the dynamic parameters
$administratorObjectId = (Get-AzADUser -Mail $administratorEmail).Id
$basicAuthenticationPassword = (Get-Content -Path $settingsPath | ConvertFrom-Json).'rest-client.environmentVariables'.'$shared'.basicAuthenticationPassword

# Login to Azure
Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

# Create application registrations if they do not yet exist
# These are used in the OAuth flows, and need to be updated in the .vscode\settings.json file when created
$apiAppRegistrationExists = Get-AzADApplication -DisplayName $apiAppRegistrationName
$clientAppRegistrationExists = Get-AzADApplication -DisplayName $clientAppRegistrationName

if (-not $apiAppRegistrationExists) {
    New-AzADApplication -DisplayName $apiAppRegistrationName -IdentifierUris "api://$apiManagementInstanceName"
}
if (-not $clientAppRegistrationExists) {
    New-AzADApplication -DisplayName $clientAppRegistrationName -IdentifierUris "api://$clientAppRegistrationName"
}

# Create the resource group and deploy the resources
New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Building better security for your API platform using Azure API Management"; Purpose="Session"}
New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\Assets\Code\IaC\azuredeploy.json" -administratorObjectId $administratorObjectId -basicAuthenticationPassword $basicAuthenticationPassword

New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\Assets\Code\IaC\api-management-api-7-logging.json"