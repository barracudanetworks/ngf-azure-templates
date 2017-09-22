# Barracuda NextGen Firewall for Azure - High Availability Cluster using Internal Load Balancer

Traditionally, Barracuda NextGen Firewall (NGF) uses UDR rewriting technique to redirect traffic when an HA failover happens. This method works well for smaller deployments, but has few drawbacks when using peered VNets or if corporate policy restricts saving AAD authentication keys in 3rd party software configuration.

Azure ILB solves above problems, providing failover capabilities with zero integration with the cloud fabric, offers shorter failover times (~15 seconds) independent of network complexity, and provides stateful failover.

This template deploys a VNet with 2 NGF instances with managed disks, an any-port ILB instance, and 2 empty subnets routed through NGF cluster.

## Prerequisites

Approve Barracuda NGF for programmatic deployments.


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbarracudanetworks%2Fngf-azure-templates%2Ftree%2Fha-ilb%2FHA%20ILB%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
