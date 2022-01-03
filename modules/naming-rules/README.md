
Custom Naming Conventions for Azure
===================================

# Overview


This repository contains a list of variables and standards for naming resources in Microsoft Azure.  It serves these 
primary purposes:  
* A central location for development teams to research and collaborate on allowed values and naming conventions.  
* A single source of truth for data values used in policy enforcement, billing, and naming.  
* A RESTful data source for application requiring information on approved values, variables and names.
## How to Use


This repository has four primary areas and their methods of use are described by the following:  
* **README.md** - The readme is the human readable documentation on the naming conventions, approved values, and 
variable names that developers will reference when creating inputs for modules and code.  
* **custom.json** - Data in json format to be RESTful sourced by applications. Contains a list of custom variable names,
 conventions, scope and approved values.  The readme is generated automatically from this data.  
* **entity.json** - Data in json format to be sourced by applications. Contains an up-to-date list of Azure resources, 
conventions, scope and approved naming conventions.  The readme is generated automatically from this data.  
* **bin/run.py** - A python script that scrapes the latest data from Microsoft merges with the existing json and adds 
new resources.  It also generates this README doc from the custom and entity json.
# Custom Entities


Custom entities are variables and allowed values that describe our business and purpose at the company and are the only 
approved values to be used in names and tags. This assures consistency and data integrity across all resources being 
named and tagged in Azure.
## custom.azureRegion

|<sub>Full Text</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Value</sub>|
| ------ | ------ | ------ | ------ |
|<sub>East Asia</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>eastasia</sub>|
|<sub>Southeast Asia</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>southeastasia</sub>|
|<sub>Central US</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>centralus</sub>|
|<sub>East US</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>eastus</sub>|
|<sub>East US 2</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>eastus2</sub>|
|<sub>West US</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>westus</sub>|
|<sub>North Central US</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>northcentralus</sub>|
|<sub>South Central US</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>southcentralus</sub>|
|<sub>North Europe</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>northeurope</sub>|
|<sub>West Europe</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>westeurope</sub>|
|<sub>Japan West</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>japanwest</sub>|
|<sub>Japan East</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>japaneast</sub>|
|<sub>Brazil South</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>brazilsouth</sub>|
|<sub>Australia East</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>australiaeast</sub>|
|<sub>Australia Southeast</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>australiasoutheast</sub>|
|<sub>South India</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>southindia</sub>|
|<sub>Central India</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>centralindia</sub>|
|<sub>West India</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>westindia</sub>|
|<sub>Canada Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>canadacentral</sub>|
|<sub>Canada East</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>canadaeast</sub>|
|<sub>UK South</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>uksouth</sub>|
|<sub>UK West</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>ukwest</sub>|
|<sub>West Central US</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>westcentralus</sub>|
|<sub>West US 2</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>westus2</sub>|
|<sub>Korea Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>koreacentral</sub>|
|<sub>Korea South</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>koreasouth</sub>|
|<sub>France Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>francecentral</sub>|
|<sub>France South</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>francesouth</sub>|
|<sub>Australia Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>australiacentral</sub>|
|<sub>Australia Central 2</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>australiacentral2</sub>|
|<sub>UAE Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>uaecentral</sub>|
|<sub>UAE North</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>uaenorth</sub>|
|<sub>South Africa North</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>southafricanorth</sub>|
|<sub>South Africa West</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>southafricawest</sub>|
|<sub>Switzerland North</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>switzerlandnorth</sub>|
|<sub>Switzerland West</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>switzerlandwest</sub>|
|<sub>Germany North</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>germanynorth</sub>|
|<sub>Germany West Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>germanywestcentral</sub>|
|<sub>Norway West</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>norwaywest</sub>|
|<sub>Norway East</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>norwayeast</sub>|
|<sub>Brazil Southeast</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>brazilsoutheast</sub>|
|<sub>US Gov Virginia</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>usgovvirginia</sub>|
|<sub>US Gov Iowa</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>usgoviowa</sub>|
|<sub>US DoD East</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>usdodeast</sub>|
|<sub>US DoD Central</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>usdodcentral</sub>|
|<sub>US Gov Texas</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>usgovtexas</sub>|
|<sub>US Gov Arizona</sub>|<sub>global</sub>|<sub>az[20]</sub>|<sub>usgovarizona</sub>|

## custom.environment

|<sub>Full Text</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Value</sub>|
| ------ | ------ | ------ | ------ |
|<sub>Terraform Testing</sub>|<sub>global</sub>|<sub>az[7]</sub>|<sub>tf</sub>|
|<sub>Sandbox</sub>|<sub>global</sub>|<sub>az[7]</sub>|<sub>sandbox</sub>|
|<sub>Development</sub>|<sub>global</sub>|<sub>az[7]</sub>|<sub>dev</sub>|
|<sub>Quality Assurance</sub>|<sub>global</sub>|<sub>az[7]</sub>|<sub>qa</sub>|
|<sub>User Acceptance Testing</sub>|<sub>global</sub>|<sub>az[7]</sub>|<sub>uat</sub>|
|<sub>Production</sub>|<sub>global</sub>|<sub>az[7]</sub>|<sub>prod</sub>|

## custom.product

|<sub>Full Text</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Value</sub>|
| ------ | ------ | ------ | ------ |
|<sub>Infrastructure as Code</sub>|<sub>global</sub>|<sub>az[12]</sub>|<sub>iac</sub>|
|<sub>OSDU</sub>|<sub>global</sub>|<sub>az[12]</sub>|<sub>osdu</sub>|
|<sub>Engineering Team</sub>|<sub>global</sub>|<sub>az[12]</sub>|<sub>engineering</sub>|

# Azure Entities


Azure entities are entities as maintained by Microsoft Azure and should contain all possible resources that can be built
 along with Microsoft's rules for record length, scope, and allowed characters.  Naming convention is specific to the 
company and takes into account the scope, length, and purpose to assure the name retains readability and conveys the 
most pertinent information about the resource to the reader.  Examples are provided. 
## azure.AnalysisServices

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>servers</sub>|<sub>resource group</sub>|<sub>a9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.ApiManagement

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>service</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>api-version-sets</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>apis</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>issues</sub>|<sub>api</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>attachments</sub>|<sub>issue</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>comments</sub>|<sub>issue</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>operations</sub>|<sub>api</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>tags</sub>|<sub>operation</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>releases</sub>|<sub>api</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>schemas</sub>|<sub>api</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>tagDescriptions</sub>|<sub>api</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>tags</sub>|<sub>api</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationServers</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>backends</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>certificates</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>diagnostics</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>groups</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>users</sub>|<sub>group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>identityProviders</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>loggers</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>notifications</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>recipientEmails</sub>|<sub>notification</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>openidConnectProviders</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>policies</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>products</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>apis</sub>|<sub>product</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>groups</sub>|<sub>product</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>tags</sub>|<sub>product</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>properties</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>subscriptions</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>tags</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>templates</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>users</sub>|<sub>service</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|

## azure.AppConfiguration

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>configurationStores</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.Authorization

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>locks</sub>|<sub>scope of assignment</sub>|<sub>a-9[90]</sub>|<sub></sub>|<sub></sub>|
|<sub>policyAssignments</sub>|<sub>scope of assignment</sub>|<sub>a-9[255]</sub>|<sub></sub>|<sub></sub>|
|<sub>policyDefinitions</sub>|<sub>scope of definition</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>policySetDefinitions</sub>|<sub>scope of definition</sub>|<sub>a-9[255]</sub>|<sub></sub>|<sub></sub>|
|<sub>roleAssignments</sub>|<sub>tenant</sub>|<sub>must be a globally unique identifier (guid).[36]</sub>|<sub></sub>|<sub></sub>|
|<sub>roleDefinitions</sub>|<sub>tenant</sub>|<sub>must be a globally unique identifier (guid).[36]</sub>|<sub></sub>|<sub></sub>|

## azure.Automation

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>automationAccounts</sub>|<sub>resource group & region <br>(See note below)</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>certificates</sub>|<sub>automation account</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>connections</sub>|<sub>automation account</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>credentials</sub>|<sub>automation account</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>runbooks</sub>|<sub>automation account</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>schedules</sub>|<sub>automation account</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>variables</sub>|<sub>automation account</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>watchers</sub>|<sub>automation account</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>webhooks</sub>|<sub>automation account</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|

## azure.Batch

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>batchAccounts</sub>|<sub>Region</sub>|<sub>a9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>applications</sub>|<sub>batch account</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>certificates</sub>|<sub>batch account</sub>|<sub>a-9[45]</sub>|<sub></sub>|<sub></sub>|
|<sub>pools</sub>|<sub>batch account</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.Blockchain

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>blockchainMembers</sub>|<sub>global</sub>|<sub>a9[20]</sub>|<sub></sub>|<sub></sub>|

## azure.BotService

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>botServices</sub>|<sub>global</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>Connections</sub>|<sub>bot service</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>channels</sub>|<sub>bot service</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>enterpriseChannels</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.Cache

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>Redis</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>Redis</sub>|<sub>a9[256]</sub>|<sub></sub>|<sub></sub>|

## azure.Cdn

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>profiles</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>endpoints</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.CertificateRegistration

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>certificateOrders</sub>|<sub>resource group</sub>|<sub>a9[30]</sub>|<sub></sub>|<sub></sub>|

## azure.CognitiveServices

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>accounts</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.Communication

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>communicationServices</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.Compute

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>availabilitySets</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>cloudservices</sub>|<sub>resource group</sub>|<sub>a-9[15 <br><br>See note below.]</sub>|<sub></sub>|<sub></sub>|
|<sub>diskEncryptionSets</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>disks</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>galleries</sub>|<sub>resource group</sub>|<sub>a9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>applications</sub>|<sub>gallery</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>versions</sub>|<sub>application</sub>|<sub>0.9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>images</sub>|<sub>gallery</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>versions</sub>|<sub>image</sub>|<sub>0.9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>images</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>snapshots</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualMachineScaleSets</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualMachines</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.Consumption

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>budgets</sub>|<sub>subscription or resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.ContainerInstance

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>containerGroups</sub>|<sub>resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.ContainerRegistry

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>registries</sub>|<sub>global</sub>|<sub>a9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>buildTasks</sub>|<sub>registry</sub>|<sub>a9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>steps</sub>|<sub>build task</sub>|<sub>a9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>replications</sub>|<sub>registry</sub>|<sub>a9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>scopeMaps</sub>|<sub>registry</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>tasks</sub>|<sub>registry</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>tokens</sub>|<sub>registry</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>webhooks</sub>|<sub>registry</sub>|<sub>a9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.ContainerService

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>managedClusters</sub>|<sub>resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>openShiftManagedClusters</sub>|<sub>resource group</sub>|<sub>a9[30]</sub>|<sub></sub>|<sub></sub>|

## azure.CustomProviders

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>associations</sub>|<sub>resource group</sub>|<sub>a-9[180]</sub>|<sub></sub>|<sub></sub>|
|<sub>resourceProviders</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.CustomerInsights

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>hubs</sub>|<sub>resource group</sub>|<sub>a9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationPolicies</sub>|<sub>hub</sub>|<sub>a9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>connectors</sub>|<sub>hub</sub>|<sub>a9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>mappings</sub>|<sub>connector</sub>|<sub>a9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>interactions</sub>|<sub>hub</sub>|<sub>a9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>kpi</sub>|<sub>hub</sub>|<sub>a9[512]</sub>|<sub></sub>|<sub></sub>|
|<sub>links</sub>|<sub>hub</sub>|<sub>a9[512]</sub>|<sub></sub>|<sub></sub>|
|<sub>predictions</sub>|<sub>hub</sub>|<sub>a9[512]</sub>|<sub></sub>|<sub></sub>|
|<sub>profiles</sub>|<sub>hub</sub>|<sub>a9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>relationshipLinks</sub>|<sub>hub</sub>|<sub>a9[512]</sub>|<sub></sub>|<sub></sub>|
|<sub>relationships</sub>|<sub>hub</sub>|<sub>a9[512]</sub>|<sub></sub>|<sub></sub>|
|<sub>roleAssignments</sub>|<sub>hub</sub>|<sub>a9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>views</sub>|<sub>hub</sub>|<sub>a9[512]</sub>|<sub></sub>|<sub></sub>|

## azure.DBforMariaDB

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>servers</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>databases</sub>|<sub>servers</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>servers</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkRules</sub>|<sub>servers</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|

## azure.DBforMySQL

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>servers</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>databases</sub>|<sub>servers</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>servers</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkRules</sub>|<sub>servers</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|

## azure.DBforPostgreSQL

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>servers</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>databases</sub>|<sub>servers</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>servers</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkRules</sub>|<sub>servers</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|

## azure.DataBox

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>jobs</sub>|<sub>resource group</sub>|<sub>a-9[24]</sub>|<sub></sub>|<sub></sub>|

## azure.DataFactory

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>factories</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>dataflows</sub>|<sub>factory</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>datasets</sub>|<sub>factory</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>integrationRuntimes</sub>|<sub>factory</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>linkedservices</sub>|<sub>factory</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>pipelines</sub>|<sub>factory</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>triggers</sub>|<sub>factory</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>rerunTriggers</sub>|<sub>trigger</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|

## azure.DataLakeAnalytics

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>accounts</sub>|<sub>global</sub>|<sub>a9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>computePolicies</sub>|<sub>account</sub>|<sub>a-9[60]</sub>|<sub></sub>|<sub></sub>|
|<sub>dataLakeStoreAccounts</sub>|<sub>account</sub>|<sub>a9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>account</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>storageAccounts</sub>|<sub>account</sub>|<sub>a-9[60]</sub>|<sub></sub>|<sub></sub>|

## azure.DataLakeStore

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>accounts</sub>|<sub>global</sub>|<sub>a9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>account</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkRules</sub>|<sub>account</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.DataMigration

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>services</sub>|<sub>resource group</sub>|<sub>a-9[62]</sub>|<sub></sub>|<sub></sub>|
|<sub>projects</sub>|<sub>service</sub>|<sub>a-9[57]</sub>|<sub></sub>|<sub></sub>|

## azure.Databricks

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>workspaces</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.DevTestLab

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>labs</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>customimages</sub>|<sub>lab</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>formulas</sub>|<sub>lab</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualmachines</sub>|<sub>lab</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.Devices

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>IotHubs</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>certificates</sub>|<sub>IoT hub</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>ConsumerGroups</sub>|<sub>eventHubEndpoints</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>provisioningServices</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>certificates</sub>|<sub>provisioningServices</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.DocumentDB

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>databaseAccounts</sub>|<sub>global</sub>|<sub>a-9[44]</sub>|<sub></sub>|<sub></sub>|

## azure.EventGrid

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>domains</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>topics</sub>|<sub>domain</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>eventSubscriptions</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>topics</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.EventHub

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>clusters</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>namespaces</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>AuthorizationRules</sub>|<sub>namespace</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>disasterRecoveryConfigs</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>eventhubs</sub>|<sub>namespace</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationRules</sub>|<sub>event hub</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>consumergroups</sub>|<sub>event hub</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.HDInsight

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>clusters</sub>|<sub>global</sub>|<sub>a-9[59]</sub>|<sub></sub>|<sub></sub>|

## azure.ImportExport

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>jobs</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|

## azure.Insights

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>actionGroups</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>activityLogAlerts</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>components</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>metricAlerts</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>scheduledQueryRules</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|

## azure.IoTCentral

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>IoTApps</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.KeyVault

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>vaults</sub>|<sub>global</sub>|<sub>a-9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>secrets</sub>|<sub>Vault</sub>|<sub>a-9[127]</sub>|<sub></sub>|<sub></sub>|

## azure.Kusto

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>databases</sub>|<sub>cluster</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>dataConnections</sub>|<sub>database</sub>|<sub>a-9[40]</sub>|<sub></sub>|<sub></sub>|
|<sub>eventhubconnections</sub>|<sub>database</sub>|<sub>a-9[40]</sub>|<sub></sub>|<sub></sub>|
|<sub>clusters</sub>|<sub>global</sub>|<sub>a9[22]</sub>|<sub></sub>|<sub></sub>|

## azure.Logic

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>integrationAccounts</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>assemblies</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>batchConfigurations</sub>|<sub>integration account</sub>|<sub>a9[20]</sub>|<sub></sub>|<sub></sub>|
|<sub>certificates</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>maps</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>partners</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>rosettanetprocessconfigurations</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>schemas</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>sessions</sub>|<sub>integration account</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>integrationServiceEnvironments</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>managedApis</sub>|<sub>integration service environment</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>workflows</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|

## azure.MachineLearning

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>commitmentPlans</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>webServices</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>workspaces</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|

## azure.MachineLearningServices

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>workspaces</sub>|<sub>resource group</sub>|<sub>a-9[33]</sub>|<sub></sub>|<sub></sub>|
|<sub>computes</sub>|<sub>workspace</sub>|<sub>a-9[16]</sub>|<sub></sub>|<sub></sub>|

## azure.ManagedIdentity

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>userAssignedIdentities</sub>|<sub>resource group</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|

## azure.Maps

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>accounts</sub>|<sub>resource group</sub>|<sub>a-9[98]</sub>|<sub></sub>|<sub></sub>|

## azure.Media

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>mediaservices</sub>|<sub>resource group</sub>|<sub>a9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>liveEvents</sub>|<sub>Media service</sub>|<sub>a-9[32]</sub>|<sub></sub>|<sub></sub>|
|<sub>liveOutputs</sub>|<sub>Live event</sub>|<sub>a-9[256]</sub>|<sub></sub>|<sub></sub>|
|<sub>streamingEndpoints</sub>|<sub>Media service</sub>|<sub>a-9[24]</sub>|<sub></sub>|<sub></sub>|

## azure.Network

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>applicationGateways</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>applicationSecurityGroups</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>azureFirewalls</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>bastionHosts</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>connections</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>dnsZones</sub>|<sub>resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>expressRouteCircuits</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallPolicies</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>ruleGroups</sub>|<sub>firewall policy</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>frontDoors</sub>|<sub>global</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>frontdoorWebApplicationFirewallPolicies</sub>|<sub>resource group</sub>|<sub>a9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>loadBalancers</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>inboundNatRules</sub>|<sub>load balancer</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>localNetworkGateways</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>networkInterfaces</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>networkSecurityGroups</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>securityRules</sub>|<sub>network security group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>networkWatchers</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>privateDnsZones</sub>|<sub>resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkLinks</sub>|<sub>private DNS zone</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>publicIPAddresses</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>publicIPPrefixes</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>routeFilters</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>routeFilterRules</sub>|<sub>route filter</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>routeTables</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>routes</sub>|<sub>route table</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>serviceEndpointPolicies</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>trafficmanagerprofiles</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkGateways</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworks</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualNetworkPeerings</sub>|<sub>virtual network</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>virtualWans</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>subnets</sub>|<sub>virtual network</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>vpnGateways</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>vpnConnections</sub>|<sub>VPN gateway</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|
|<sub>vpnSites</sub>|<sub>resource group</sub>|<sub>a-9[80]</sub>|<sub></sub>|<sub></sub>|

## azure.NotificationHubs

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>namespaces</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>AuthorizationRules</sub>|<sub>namespace</sub>|<sub>a-9[256]</sub>|<sub></sub>|<sub></sub>|
|<sub>notificationHubs</sub>|<sub>namespace</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>AuthorizationRules</sub>|<sub>notification hub</sub>|<sub>a-9[256]</sub>|<sub></sub>|<sub></sub>|

## azure.OperationalInsights

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>clusters</sub>|<sub>resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>workspaces</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.OperationsManagement

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>solutions</sub>|<sub>workspace</sub>|<sub>for solutions authored by microsoft, the name must be in the pattern:<br>`solutiontype(workspacename)`<br><br>for solutions authored by third parties, the name must be in the pattern:<br>`solutiontype[workspacename]`<br><br>for example, a valid name is:<br>`antimalware(contoso-it)`<br><br>the solution type is case-sensitive.[N/A]</sub>|<sub></sub>|<sub></sub>|

## azure.Portal

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>dashboards</sub>|<sub>resource group</sub>|<sub>a-9[160]</sub>|<sub></sub>|<sub></sub>|

## azure.PowerBI

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>workspaceCollections</sub>|<sub>region</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.PowerBIDedicated

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>capacities</sub>|<sub>region</sub>|<sub>a9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.RecoveryServices

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>vaults</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>backupPolicies</sub>|<sub>vault</sub>|<sub>a-9[150]</sub>|<sub></sub>|<sub></sub>|

## azure.Relay

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>namespaces</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>AuthorizationRules</sub>|<sub>namespace</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>HybridConnections</sub>|<sub>namespace</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationRules</sub>|<sub>hybrid connection</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>WcfRelays</sub>|<sub>namespace</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationRules</sub>|<sub>Wcf relay</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.Resources

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>deployments</sub>|<sub>resource group</sub>|<sub>a-9[64]</sub>|<sub></sub>|<sub></sub>|
|<sub>resourcegroups</sub>|<sub>subscription</sub>|<sub>a-9[90]</sub>|<sub></sub>|<sub></sub>|
|<sub>tagNames</sub>|<sub>resource</sub>|<sub>a-9[512]</sub>|<sub></sub>|<sub></sub>|
|<sub>tagValues</sub>|<sub>tag name</sub>|<sub>a-9[256]</sub>|<sub></sub>|<sub></sub>|
|<sub>templateSpecs</sub>|<sub>resource group</sub>|<sub>a-9[90]</sub>|<sub></sub>|<sub></sub>|

## azure.Security

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>advancedThreatProtectionSettings</sub>|<sub>resource group</sub>|<sub>must be `current`[see value]</sub>|<sub></sub>|<sub></sub>|
|<sub>alertsSuppressionRules</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>assessmentMetadata</sub>|<sub>assessment type</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>assessments</sub>|<sub>assessment type</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>autoProvisioningSettings</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>automations</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>connectors</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>deviceSecurityGroups</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>informationProtectionPolicies</sub>|<sub>resource group</sub>|<sub>use one of:<br>`custom`<br>`effective`[see values]</sub>|<sub></sub>|<sub></sub>|
|<sub>ingestionSettings</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>iotSecuritySolutions</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>applicationWhitelistings</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>jitNetworkAccessPolicies</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>pricings</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>securityContacts</sub>|<sub>subscription</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>serverVulnerabilityAssessments</sub>|<sub>resource type</sub>|<sub>default[see value]</sub>|<sub></sub>|<sub></sub>|
|<sub>settings</sub>|<sub>subscription</sub>|<sub>use one of:<br>`mcas`<br>`sentinel`<br>`wdatp`<br>`wdatp_exclude_linux_public_preview`[see values]</sub>|<sub></sub>|<sub></sub>|
|<sub>baselineRules</sub>|<sub>Vulnerability assessment</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|

## azure.ServiceBus

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>namespaces</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>AuthorizationRules</sub>|<sub>namespace</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>disasterRecoveryConfigs</sub>|<sub>global</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>migrationConfigurations</sub>|<sub>namespace</sub>|<sub>default[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>queues</sub>|<sub>namespace</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationRules</sub>|<sub>queue</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>topics</sub>|<sub>namespace</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>authorizationRules</sub>|<sub>topic</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>subscriptions</sub>|<sub>topic</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|
|<sub>rules</sub>|<sub>subscription</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.ServiceFabric

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>clusters</sub>|<sub>region</sub>|<sub>a-9[23]</sub>|<sub></sub>|<sub></sub>|

## azure.SignalRService

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>signalR</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.Sql

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>managedInstances</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>servers</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>administrators</sub>|<sub>server</sub>|<sub>must be `activedirectory`.[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>databases</sub>|<sub>server</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>syncGroups</sub>|<sub>database</sub>|<sub>a-9[150]</sub>|<sub></sub>|<sub></sub>|
|<sub>elasticPools</sub>|<sub>server</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>failoverGroups</sub>|<sub>global</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>firewallRules</sub>|<sub>server</sub>|<sub>a-9[128]</sub>|<sub></sub>|<sub></sub>|
|<sub>keys</sub>|<sub>server</sub>|<sub>must be in format:<br>`vaultname_keyname_keyversion`.[63]</sub>|<sub></sub>|<sub></sub>|

## azure.StorSimple

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>managers</sub>|<sub>resource group</sub>|<sub>a-9[50]</sub>|<sub></sub>|<sub></sub>|

## azure.Storage

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>blob</sub>|<sub>container</sub>|<sub>a-9[1024]</sub>|<sub></sub>|<sub></sub>|
|<sub>queue</sub>|<sub>storage account</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>storageAccounts</sub>|<sub>global</sub>|<sub>a9[24]</sub>|<sub></sub>|<sub></sub>|
|<sub>blobServices</sub>|<sub>storage account</sub>|<sub>default[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>containers</sub>|<sub>storage account</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>fileServices</sub>|<sub>storage account</sub>|<sub>default[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>shares</sub>|<sub>storage account</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>managementPolicies</sub>|<sub>storage account</sub>|<sub>default[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>table</sub>|<sub>storage account</sub>|<sub>a9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.StorageSync

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>storageSyncServices</sub>|<sub>resource group</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>syncGroups</sub>|<sub>storage sync service</sub>|<sub>a-9[260]</sub>|<sub></sub>|<sub></sub>|

## azure.StreamAnalytics

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>streamingjobs</sub>|<sub>resource group</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>functions</sub>|<sub>streaming job</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>inputs</sub>|<sub>streaming job</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>outputs</sub>|<sub>streaming job</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|
|<sub>transformations</sub>|<sub>streaming job</sub>|<sub>a-9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.TimeSeriesInsights

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>environments</sub>|<sub>resource group</sub>|<sub>a-9[90]</sub>|<sub></sub>|<sub></sub>|
|<sub>accessPolicies</sub>|<sub>environment</sub>|<sub>a-9[90]</sub>|<sub></sub>|<sub></sub>|
|<sub>eventSources</sub>|<sub>environment</sub>|<sub>a-9[90]</sub>|<sub></sub>|<sub></sub>|
|<sub>referenceDataSets</sub>|<sub>environment</sub>|<sub>a9[63]</sub>|<sub></sub>|<sub></sub>|

## azure.Web

|<sub>Entity</sub>|<sub>Scope</sub>|<sub>Rule</sub>|<sub>Convention</sub>|<sub>Example</sub>|
| ------ | ------ | ------ | ------ | ------ |
|<sub>certificates</sub>|<sub>resource group</sub>|<sub>can't use:<br>`/` <br><br>can't end with space or period.[260]</sub>|<sub></sub>|<sub></sub>|
|<sub>serverfarms</sub>|<sub>resource group</sub>|<sub>a-9[40]</sub>|<sub></sub>|<sub></sub>|
|<sub>sites</sub>|<sub>global or per domain. See note below.</sub>|<sub>a-9[60]</sub>|<sub></sub>|<sub></sub>|
|<sub>slots</sub>|<sub>site</sub>|<sub>a-9[59]</sub>|<sub></sub>|<sub></sub>|
