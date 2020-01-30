# Barracuda CloudGen Firewall for Azure - Log Analytics Workspace

## Introduction

This Log Analytics Workspace is intended to provide you a quick overview of;

- Availability
- Performance
- VPN Status
- Firewall Protection


It uses the default performance data provided to OMS via the installation of the OMS extension. This is intended to be deployed into an existing Log Analytics workspace.



The CloudGen Firewall can input into OMS any of it's logs via syslog and these can be used to create custom reports in further detail. 

## Prerequisites

1. Connect your firewall to Log Analytics via Log Analytics > Virtual Machines, find your VM and select Connect. Alternatively follow Step 2 of (https://campus.barracuda.com/product/cloudgenfirewall/doc/79463434/how-to-configure-azure-oms-log-streaming/)

2. To enable detailed Firewall reporting, go to Configuration Tree > Infrastructure Services > General Firewall Configuration and change Activity Log Mode to "Log-Pipe-Seperated-Key-Value-List". 
![Enable Firewall Activity Log](images/enableactivitylog.png)

Alternatively copy the contents of GeneralFirewallConfiguration.conf into you clipboard and Im/Export > Merge from Clipboard to update the fields. 


3. To setup the additional Syslog Streaming go to Configuration Tree > Infrastructure Services > Syslog Streaming.If this box has connected to Log Analytics you should already a OMSSecurity Destination. 

You can point any of the available logs towards this destination, but the searches in this template are configured to analyse the following Log Groups therefore it is recommended to add these filters and send them to the OMS destination.
- Auth-All 
- Firewall-Activity-Only
- Config-All

To get these configured quickly, you can copy the contents of SyslogStreaming.conf into your clipboard and choose to Im/Export > Merge from Clipboard to create just those fields.

Otherwise;
* Create a New Logstream Destination named OMS and select Microsoft OMS from the Logstream Destination dropdown.
* Create the Logdata Filters, add 3 new filters one for each of the types listed above.
* Go to Logdata Streams and create a new stream associating the new OMS destination with the new Log Filters created above.

For more details on configuring these please see;

(https://campus.barracuda.com/product/cloudgenfirewall/doc/79463292/how-to-configure-syslog-streaming/?sl=AW7vcc5m7X_svXEFw7Ox&so=10)

## Deployment

Deployment of the ARM template is possible via the Azure Portal, Powershell or Azure CLI. 

### Azure Portal

To deploy via Azure Portal you can use the button below to deploy this Log Analytics Dashboard into an existing Log Anayltics Workspace. Once you click on this the Azure Portal will ask you for your credentials and you are presented with a page to fill in minimal variables: Resource Group and Workspace name.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbarracudanetworks%2Fngf-azure-templates%2Fmaster%2FCGF-LogAnalytics-Dashboard%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fbarracudanetworks%2Fngf-azure-templates%2Fmaster%2FCGF-LogAnalytics-Dashboard%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

 
## Azure Sentinel Workbook

This template also includes supporting functions that enable the Azure Sentinel Workbook to process data directly from the existing output of the Firewalls.

## Troubleshooting
On older versions of Firmware the OMS agent may 


##### DISCLAIMER: ALL OF THE SOURCE CODE ON THIS REPOSITORY IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL BARRACUDA BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOURCE CODE. #####
