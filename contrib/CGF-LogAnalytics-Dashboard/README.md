# Barracuda CloudGen Firewall for Azure - Log Analytics Workspace

## Introduction

This Log Analytics Workspace is intended to provide you a quick overview of;

Availability
Performance
VPN Status
Firewall Protection


It uses the default performance data provide to OMS via the installation of the OMS extension. This is intended to be deployed into an existing Log Analytics workspace.



The CloudGen Firewall can input into OMS any of it's logs via syslog and these can be used to create custom reports in further detail. 


## Deployment

Deployment of the ARM template is possible via the Azure Portal, Powershell or Azure CLI. 

### Azure Portal

To deploy via Azure Portal you can use the button below to deploy this Log Analytics Dashboard into an existing Log Anayltics Workspace. Once you click on this the Azure Portal will ask you for your credentials and you are presented with a page to fill in minimal variables: Resource Group and Workspace name.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbarracudanetworks%2Fngf-azure-templates%2Fmaster%2Fcontrib%2FCGF-LogAnalytics-Dashboard%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fbarracudanetworks%2Fngf-azure-templates%2Fmaster%2Fcontrib%2FCGF-LogAnalytics-Dashboard%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

 
##### DISCLAIMER: ALL OF THE SOURCE CODE ON THIS REPOSITORY IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL BARRACUDA BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOURCE CODE. #####
