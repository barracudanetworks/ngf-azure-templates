# Barracuda CloudGen Firewall for Azure - ARM templates

## Introduction

The Barracuda CloudGen Firewall (CGF) can be installed in different ways into the Microsoft Azure platform. This repository contains different methods using existing supported methods as well as methods that are in Preview on the Microsoft Azure platform. In the table below you can see which ARM Template contains which features.

![Network diagram](CGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD/images/cgf-ha-1nic-elb-ilb.png)

## Template Parameters
| Status | Name | In existing VNET | HighAvailability | ELB Basic | ELB Standard | ILB with HA Ports | Availability Zones | 1 NIC | 2 NIC 
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:
| ![Build Status](https://dev.azure.com/gallen0262/cudasedevops/_build/latest?definitionId=5&branchName=master) | [CGF-Custom-HA-1NIC-AS-ELB-ILB-STD](https://github.com/barracudanetworks/ngf-azure-templates/tree/master/CGF-Custom-HA-1NIC-AS-ELB-ILB-STD) | X | X | - | X | X | - | X | - 
| ![Build status](https://dev.azure.com/gallen0262/cudasedevops/_apis/build/status/CGF-Quickstart-HA-1NIC-AS-ELB-ILB-STD) | [CGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD](https://github.com/barracudanetworks/ngf-azure-templates/tree/master/CGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD) | - | X | - | X | X | X | X | - 
| | [CGF-LogAnalytics-Dashboard](https://github.com/barracudanetworks/ngf-azure-templates/tree/master/CGF-LogAnalytics-Dashboard) | - | - | - |- | - | -| - | - 

More templates can be found within the Contrib directory.


##### DISCLAIMER: ALL OF THE SOURCE CODE ON THIS REPOSITORY IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL BARRACUDA BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOURCE CODE. #####
