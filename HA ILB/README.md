# Barracuda NextGen Firewall for Azure - High Availability Cluster using Internal Load Balancer

Traditionally, Barracuda NextGen Firewall (NGF) uses UDR rewriting technique to redirect traffic when an HA failover happens. This method works well for smaller deployments, but has few drawbacks when using peered VNets or if corporate policy restricts saving AAD authentication keys in 3rd party software configuration.

Azure ILB solves above problems, providing failover capabilities with zero integration with the cloud fabric, offers shorter failover times (~15 seconds) independent of network complexity, and provides stateful failover.

This template deploys a VNet with 2 NGF instances with managed disks, an any-port ILB instance, and 2 empty subnets routed through NGF cluster.

![Network diagram](https://raw.githubusercontent.com/barracudanetworks/ngf-azure-templates/master/HA%20ILB/Azure%20-%20ha%20ilb%20with%20subnets.png)

## Prerequisites

Approve Barracuda NGF for programmatic deployments.

## Deployment

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbarracudanetworks%2Fngf-azure-templates%2Fmaster%2FHA%20ILB%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>

## Next Steps

After successful deployment you can manage them using NextGen Admin application available from Barracuda Download Portal. Management IP addresses you'll find in firewall instances properties, username is *root* and the password is what you provided during template deployment.

## Post Deployment Configuration

You need to create manually a firewall *App Redirect* rule for ILB Probe traffic. The connection will use the port you indicated during template deployment and it will originate from 168.63.129.16 and can be redirected to any service running locally on NGF (e.g. 127.0.0.1:451 for firewall authentication service)

![Example firewall probe redirection rule](https://raw.githubusercontent.com/barracudanetworks/ngf-azure-templates/master/HA%20ILB/Probe%20Firewall%20Rule.png)

For more information on App Redirect rule consult Barracuda Campus: [How to Create an App Redirect Access Rule](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/FWCreateAppRedirRule/)

It is also recommended you harden management access by enabling multifactor or key authentication and by restricting access to management interface using Management ACL: [How to Change the Root Password and Management ACL](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/ChangeRootPWandMgmtACL/)
