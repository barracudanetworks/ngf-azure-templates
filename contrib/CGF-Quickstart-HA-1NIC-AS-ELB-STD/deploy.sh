#!/bin/bash
echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#
# Script to deploy the Barracuda CloudGen Firewall into Microsoft Azure. This is a quickstart script which 
# also creates the network infrastructure needed for it.
#
##############################################################################################################

"

# Stop on error
set +e

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
else
    passwd="$DEPLOY_PASSWORD"
    echo ""
    echo "--> Using password found in env variable DEPLOY_PASSWORD ..."
    echo ""
fi

# Create resource group for NextGen Firewall resources
echo ""
echo "--> Creating $rg_ngf resource group ..."
az group create --location "$location" --name "$rg_ngf"

# Validate template
echo "--> Validation deployment in $rg_ngf resource group ..."
az group deployment validate --verbose --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
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
                           --parameters adminPassword=$passwd prefix=$prefix
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment failed ..."
    exit $rc; 
else 
echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#
# Thank you for deploying the Barracuda CloudGen Firewall for more information:
#
# Campus website:
# https://campus.barracuda.com/product/cloudgenfirewall/doc/96026610/
#
# Connect via email:
# azure_support@barracuda.com
#
##############################################################################################################
 IP Assignment:
"
query="[?virtualMachine.name.starts_with(@, '$prefix')].{virtualMachine:virtualMachine.name, publicIP:virtualMachine.network.publicIpAddresses[0].ipAddress,privateIP:virtualMachine.network.privateIpAddresses[0]}"
az vm list-ip-addresses --query "$query" --output tsv
echo "
##############################################################################################################
"
fi

exit 0