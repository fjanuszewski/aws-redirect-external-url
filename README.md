# Description

This repository has a cloudformation (template.yml file) and an HTML (dist / index.html) where only one redirect will be found.

This makes sense when our bucket already exists and we can't use the same name, or when we can't redirect from S3.

In case the bucket already exists, you should change the name of the bucket in reference in the cloudformation template.

- S3 bucket: For storage the static WebSite
- CloudFront Distribution: CloudFront Distribution for a S3 Static WebSite
- Route 53 For domain to Redirect

## Before starting
Must have installed AWS CLI and SAM. After install AWS CLI configure the AWS CLI to execute the commands in your AWS account.

NodeJs is required for Build the lambda trigger.

### Installing AWS CLI & SAM
- [AWS CLI Installer](https://docs.aws.amazon.com/es_es/cli/latest/userguide/cli-chap-install.html)
- [SAM Installer](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)


# Usage
You can either implement the tamplate with your favorite SAM command, or run the **deploy.sh** file. Note that you should replace the variables within the file.

### Environments
- **ENV**: This work fine if we use SAM in local. In Pipeline is not needed
- **BUCKET**: Bucket is required for [SAM Package](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-package.html)
- **STACK**: Name of stack in CloudFormation, is reference for the name of objects in template
- **PROJECT**: Tag for all resources
- **DOMAIN**: Domain for Route53
- **SUBDOMAIN**: SubDomain for Route53
- **CERTARN**: SSL Cert ARN for CloudFront
- **AWS_PROFILE**: Profile for AWS CLI

### HTML for redirect
The file is stored in **dist/index.html**, before to deploy, you need change the url in HTML
```
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="refresh" content="0; url=https://yourweb.com">
</head>
<body>
</body>
</html>


```