## AWS Security Related Setup

### ALB and Security groups
* http and https listeners are available, http forwards to https
* monitoring is enabled
* WAF is enabled
* `Drop invalid headers` is enabled
* access log is enabled

### EKS and TG
* TG only allows connections from ALB
* EKS endpoint is secured - only whitelisted IPs are allowed
* EKS is up to date
* logging is enabled
* EKS backup is in encrypted bucket
* EBS/EFS volumes are encrypted

### S3
* buckets are encrypted
* TODO - MFA is required to delete the bucket
* only https access is allowed
* buckets are not world listable, world readable nor world writable
* TODO - bucket access is logged

### CloudFront
* access to the bucket is allowed only using CF for webhosting buckets
* https is enforced

### RDS
* encrypted databases
* encrypted snapshots and exports to S3
* enforced SSL when connecting
* 14/30 days of snapshots

### WAF
* WAF is enabled for endpoints (ALB, CF, API GW)
* WAF logging is enabled
* the following rules are enabled:
```
waf-rate-limit
AWS-AWSManagedRulesAdminProtectionRuleSet
AWS-AWSManagedRulesAmazonIpReputationList
AWS-AWSManagedRulesKnownBadInputsRuleSet
AWS-AWSManagedRulesCommonRuleSet
```

### API GW
* https is configured with valid certificate

### CloudTrail
* CT is enabled account-wide and is logging audit log

### VPC
* default SG is not used
* SG does not whitelist VPC CIDR
* TODO flow logs on subnets / nat gw

### EC2
* EBS volumes are encrypted
* EFS volumes are encrypted
* snapshots are encrypted
* no secrets in instance user data

### SNS
* topics are encrypted

### IAM
* MFA is used for admin accounts

