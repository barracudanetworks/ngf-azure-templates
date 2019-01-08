#!/bin/bash
echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#                                                    
# Script to deploy the Barracuda Next Gen Firewall F into Microsoft Azure. This script does NOT create the
# network infrastructure needed for it. This can be injected into an existing network infrastructure.
# Edit the azuredeploy.parameters.json file according to your network infrastructure.
#
##############################################################################################################
"

# Stop on error
set +e

while getopts l:x:p: option
do
 case "${option}"
 in
 l) DEPLOY_LOCATION=${OPTARG};;
 x) DEPLOY_PREFIX=${OPTARG};;
 p) DEPLOY_PASSWORD=${OPTARG};;
 esac
done

if [ -z "$DEPLOY_LOCATION" ]
then
    # Input location 
    echo -n "Enter location (e.g. eastus2): "
    stty_orig=`stty -g` # save original terminal setting.
    read location         # read the location
    stty $stty_orig     # restore terminal setting.
    if [ -z "$location" ] 
    then
        location="eastus2"
    fi
else
    location="$DEPLOY_LOCATION"
fi
echo ""
echo "--> Deployment in $location location ..."
echo ""

if [ -z "$DEPLOY_PREFIX" ]
then
    # Input prefix 
    echo -n "Enter prefix: "
    stty_orig=`stty -g` # save original terminal setting.
    read prefix         # read the prefix
    stty $stty_orig     # restore terminal setting.
    if [ -z "$prefix" ] 
    then
        prefix="CUDA"
    fi
else
    prefix="$DEPLOY_PREFIX"
fi
echo ""
echo "--> Using prefix $prefix for all resources ..."
echo ""
rg_ngf="$prefix-RG"

if [ -z "$DEPLOY_PASSWORD" ]
then
    # Input password 
    echo -n "Enter password: "
    stty_orig=`stty -g` # save original terminal setting.
    stty -echo          # turn-off echoing.
    read passwd         # read the password
    stty $stty_orig     # restore terminal setting.
    echo ""
else
    passwd="$DEPLOY_PASSWORD"
    echo ""
    echo "--> Using password found in env variable DEPLOY_PASSWORD ..."
    echo ""
fi
                           
if [ -z "$DEPLOY_VNETRESOURCEGROUP" ]
then
    # Input prefix 
    echo -n "Enter the resource group name of the VNET: "
    stty_orig=`stty -g` # save original terminal setting.
    read vnetresourcegroup         # read the variable
    stty $stty_orig     # restore terminal setting.
    if [ -z "$vnetresourcegroup" ] 
    then
        vnetresourcegroup="CUDA-RG-VNET"
    fi
else
    prefix="$DEPLOY_VNETRESOURCEGROUP"
fi
echo ""
echo "--> Using following VNET Resource Group $vnetresourcegroup ..."
echo ""

if [ -z "$DEPLOY_VNETNAME" ]
then
    # Input prefix 
    echo -n "Enter the VNET name: "
    stty_orig=`stty -g` # save original terminal setting.
    read vnetname         # read the variable
    stty $stty_orig     # restore terminal setting.
    if [ -z "$vnetname" ] 
    then
        vnetname="CUDA-VNET"
    fi
else
    vnetname="$DEPLOY_VNETNAME"
fi
echo ""
echo "--> Using VNET Name $vnetname ..."
echo ""

if [ -z "$DEPLOY_SUBNETNAMENGF" ]
then
    # Input prefix 
    echo -n "Enter the name of the NGF Subnet: "
    stty_orig=`stty -g` # save original terminal setting.
    read subnetnamengf         # read the variable
    stty $stty_orig     # restore terminal setting.
    if [ -z "$subnetnamengf" ] 
    then
        subnetnamengf="CUDA-SUBNET-NGF"
    fi
else
    subnetnamengf="$DEPLOY_SUBNETNAMENGF"
fi
echo ""
echo "--> Using prefix $subnetnamengf for all resources ..."
echo ""

if [ -z "$DEPLOY_SUBNETNGF" ]
then
    # Input prefix 
    echo -n "Enter the IP range of the NGF Subnet (e.g. 172.16.136.0/24): "
    stty_orig=`stty -g` # save original terminal setting.
    read subnetngf         # read the variable
    stty $stty_orig     # restore terminal setting.
    if [ -z "$subnetngf" ] 
    then
        subnetnamengf="172.16.136.0/24"
    fi
else
    subnetnamengf="$DEPLOY_SUBNETNGF"
fi
echo ""
echo "--> Using prefix $subnetngf for all resources ..."
echo ""

# Create resource group for NextGen Firewall resources
echo ""
echo "--> Creating $rg_ngf resource group ..."
az group create --location "$location" --name "$rg_ngf"

# Validate template
echo "--> Validation deployment in $rg_ngf resource group ..."
az group deployment validate --verbose --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix vNetResourceGroup=$vnetresourcegroup \
                                        vNetName=$vnetname subnetNameNGF=$subnetnamengf subnetNGF=$subnetngf
result=$? 
if [ $result != 0 ]; 
then 
    echo "--> Validation failed ..."
    exit $rc; 
fi

# Deploy NextGen Firewall resources
echo "--> Deployment of $rg_ngf resources ..."
az group deployment create --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix vNetResourceGroup=$vnetresourcegroup \
                                        vNetName=$vnetname subnetNameNGF=$subnetnamengf subnetNGF=$subnetngf
result=$? 
if [ $result != 0 ]; 
then 
    echo "--> Deployment failed ..."
    exit $rc; 
fi
