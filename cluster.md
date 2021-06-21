## General
* use `eu-central-1` region

## VPC
* we usually create each cluster and associated resources such as RDS in a separate VPC
* create 3 private subnets, 3 public subnets, NAT gw

## EKS cluster
* last tested with `1.18`
* for the demo deployment create 1 node group with 2 t3.medium nodes, 30 GB of SSD storage per node
* use private subnets for the cluster
* auto scaling group should be created for the node group
* allow access to ports 30080/TCP and 30880/TCP
* setup auth configmap
* allow a safe IP access to API

## Target Group
* create target group, instance port is `30080/http`
* use port `30880/http`, path `/ping` for the health check - health check will fail until Traefik ingress is deployed in the cluster
* include both nodes in the TG (or you can associate it in ASG config)
* once Traefik is deployed (first step in [operator.md](https://github.com/braintribehq/sns-resources/blob/main/operator.md)) check that both nodes are listed as healthy

## Application Load Balancer
* create an ALB
* issue new SSL certifcate for the ALB
* point traffic to the TG created in the previous step
* create new DNS CNAME to access the ALB, setup HTTP -> HTTPS redirect, custom error page

## Next steps (not needed for the demo)
* logging and monitoring with CloudWatch
* metrics server in the cluster 
* PV provisioning for the EKS cluster
* setup WAF
* ALB access logs + Athena
* ...

## Included terraform resources
Please read through the `terraform` folder, it includes what we used some time ago for a test cluster. The script itself will not work because of missing automation framework but parameters used for various resources should provide some value.