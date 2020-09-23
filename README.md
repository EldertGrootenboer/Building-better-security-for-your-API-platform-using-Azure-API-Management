# Building better security for your API platform using Azure API Management

These days we use APIs to expose all our microservices , processes, and data, and all this while working in a PaaS or serverless environment. But how do we ensure this is done in a secure and governed way?

This is where Azure API Management comes in, where we can create a repository of all our APIs, and make sure to expose all of these securely in a standardized manner. In this session we will dive into the most common security hazards, and see how API Management helps us solve these. You will learn all about the strengths and weaknesses of the product, best practices, and how to harden the defenses of your services.

## Secrets

This assumes you're working with Visual Studio Code. Create a folder in the root of this repository called .vscode, and add a file called settings.json. In this file, place the following content, and adjust according to your own environment.

```json
{
    "rest-client.environmentVariables": {
        "$shared": {
            "basicAuthenticationPassword": "MyAwesomePassword", // Set any password you like, do this before deployment as it will be dynamically retrieved from the deployment script.
            "apiManagementSubscriptionKey": "aaaaaaaaaaaabbbbbbbbbbbbbb111111111111", // Retrieve from API Management after deployment.
            "tenantId": "aaaaaaaa-bbbb-cccc-1111-222222222222", // Retrieve from Azure Active Directory on the Overview blade
            "clientId": "dddddddd-eeee-ffff-3333-444444444444", // Retrieve from Azure Active Directory after creating the app registrations described on https://bit.ly/api-management-oauth-aad.
            "clientSecret": "aHwem27j-as_-Aw~ax-asJMNs6G1JKwweQ", // Created during creating the app registrations described on https://bit.ly/api-management-oauth-aad.
            "scope": "api://api-app-registration-scope-name/.default" // Configured during creating the app registrations described on https://bit.ly/api-management-oauth-aad.
        }
    }
}
```

## Deployment

Deploying the Azure resources can be done by running the script [1-create-app-registrations-for-oauth-demo.ps1](./Assets/Code/IaC/1-create-app-registrations-for-oauth-demo.ps1).