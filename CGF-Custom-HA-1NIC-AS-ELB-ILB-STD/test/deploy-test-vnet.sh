#!/bin/bash
echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#                                                    
# Script to deploy test network infrastructure for the custom CGF HA setup.
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

# Variables
rg_vnet="$prefix-RG-VNET"
vnet_name="$prefix-VNET"
vnet_address_space="172.16.136.0/22"
subnet_ngf_name="$prefix-SUBNET-CGF"
subnet_ngf="172.16.136.0/24"
subnet_red_name="$prefix-SUBNET-RED"
subnet_red="172.16.137.0/24"
subnet_green_name="$prefix-SUBNET-GREEN"
subnet_green="172.16.138.0/24"

# Create resource group for NextGen Firewall resources
echo -e "\nCreating $rg_vnet resource group ...\n"
az group create --location "$location" --name "$rg_vnet"

# Create VNET for NextGen Firewall resources
az network vnet create \
    --name "$vnet_name" \
    --resource-group "$rg_vnet" \
    --location "$location" \
    --address-prefix "$vnet_address_space" \
    --subnet-name "$subnet_ngf_name" \
    --subnet-prefix "$subnet_ngf"
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment VNET failed ..."
    exit $rc; 
else
    echo "--> Deployment VNET succeeded ..."
fi

az network vnet subnet create \
    --address-prefix $subnet_red \
    --name $subnet_red_name \
    --resource-group $rg_vnet \
    --vnet-name $vnet_name
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment RED SUBNET failed ..."
    exit $rc; 
else
    echo "--> Deployment RED SUBNET succeeded ..."
fi

az network vnet subnet create \
    --address-prefix $subnet_green \
    --name $subnet_green_name \
    --resource-group $rg_vnet \
    --vnet-name $vnet_name
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment GREEN SUBNET failed ..."
    exit $rc; 
else
    echo "--> Deployment GREEN SUBNET succeeded ..."
fi
