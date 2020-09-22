# What we will be doing in this script.
#   1. Create a app registration for the API, if not exists
#   2. Create a app registration for the consumer, if not exists
#   3. Create a resource group
#   4. Deploy Azure services

$subscriptionName = "Visual Studio Enterprise"
$apiAppRegistrationName = "api-app-registration-api-platform-security"
$clientAppRegistrationName = "client-app-registration-api-platform-security"
$apiManagementInstanceName = "apim-api-platform-security-2"
$resourceGroupName = "rg-arm-in-a-serverless-world-2"
$basePath = "C:\Users\elder\OneDrive\Sessions\Azure-Resource-Manager-in-A-Serverless-World"

Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

$apiAppRegistrationExists = Get-AzADApplication -DisplayName $apiAppRegistrationName
$clientAppRegistrationExists = Get-AzADApplication -DisplayName $clientAppRegistrationName

if (-not $apiAppRegistrationExists) {
    New-AzADApplication -DisplayName $apiAppRegistrationName -IdentifierUris "api://$apiManagementInstanceName"
}
if (-not $clientAppRegistrationExists) {
    New-AzADApplication -DisplayName $clientAppRegistrationName -IdentifierUris "api://$clientAppRegistrationName"
}

New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Azure Resource Manager In A Serverless World"; Purpose="Session"}
New-AzResourceGroupDeployment -Name Demo2 -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\Assets\Code\IaC\azuredeploy.json"
