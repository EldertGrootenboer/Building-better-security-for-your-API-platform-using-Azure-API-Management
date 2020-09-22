# What we will be doing in this script.
#   1. Create a app registration for the API
#   2. Create a app registration for the consumer

$subscriptionName = "Visual Studio Enterprise"
$apiAppRegistrationName = "api-app-registration-api-platform-security"
$clientAppRegistrationName = "client-app-registration-api-platform-security"
$apiManagementInstanceName = "apim-api-platform-security"

Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

$apiAppRegistrationExists = Get-AzADApplication -DisplayName $apiAppRegistrationName
$clientAppRegistrationExists = Get-AzADApplication -DisplayName $clientAppRegistrationName

if (-not $apiAppRegistrationExists) {
    New-AzADApplication -DisplayName $apiAppRegistrationName -IdentifierUris "api://$apiManagementInstanceName"
}
if (-not $clientAppRegistrationExists) {
    New-AzADApplication -DisplayName $clientAppRegistrationName -IdentifierUris "api://$clientAppRegistrationName"
}
