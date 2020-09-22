# What we will be doing in this script.
#   1. Create a app registration for the API, if not exists
#   2. Create a app registration for the consumer, if not exists
#   3. Create a resource group
#   4. Deploy Azure services

$subscriptionName = "Visual Studio Enterprise"
$apiAppRegistrationName = "api-app-registration-api-platform-security"
$clientAppRegistrationName = "client-app-registration-api-platform-security"
$apiManagementInstanceName = "apim-api-platform-security-3"
$resourceGroupName = "rg-rg-api-platform-security"
$basePath = "C:\Users\elder\OneDrive\Sessions\Building-better-security-for-your-API-platform-using-Azure-API-Management"

Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

$apiAppRegistrationExists = Get-AzADApplication -DisplayName $apiAppRegistrationName
$clientAppRegistrationExists = Get-AzADApplication -DisplayName $clientAppRegistrationName

if (-not $apiAppRegistrationExists) {
    New-AzADApplication -DisplayName $apiAppRegistrationName -IdentifierUris "api://$apiManagementInstanceName"
}
if (-not $clientAppRegistrationExists) {
    New-AzADApplication -DisplayName $clientAppRegistrationName -IdentifierUris "api://$clientAppRegistrationName"
}

New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Building better security for your API platform using Azure API Management"; Purpose="Session"}

#$administratorObjectId = ConvertTo-SecureString (Get-AzADUser -Mail "me@eldert.net" | Select-Object -ExpandProperty Id | Out-String) -AsPlainText -Force
$administratorObjectId = ConvertTo-SecureString "2fe35e55-b3ac-4c86-a18f-97ef0dc4615d" -AsPlainText -Force
$basicAuthenticationPassword = ConvertTo-SecureString "QXBpUGxhdGZvcm1TZWN1cml0eTpQYXNzQHdvcmQx" -AsPlainText -Force
$administratorObjectId = "2fe35e55-b3ac-4c86-a18f-97ef0dc4615d"
$basicAuthenticationPassword = "QXBpUGxhdGZvcm1TZWN1cml0eTpQYXNzQHdvcmQx"

New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\Assets\Code\IaC\azuredeploy.json" -administratorObjectId $administratorObjectId -basicAuthenticationPassword $basicAuthenticationPassword
