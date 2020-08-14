#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# VARIABLES ESTANDAR
ENV=XXXXX #THIS WORK FINE IF WE USE SAM IN LOCAL. IN PIPELINE IS NOT NEED
BUCKET=XXXXX #BUCKET IS REQUIRED FOR SAM PACKAGE
DOMAIN="XXXXX"
SUBDOMAIN="XXXXX"

CERTARN="XXXXX"

STACK=XXXXX #NAME OF STACK, IS IMPORTANT FOR THE NAME OF ALL OBJECTS IN TEMPLATE
PROJECT=XXXXX #PROJECT NAME FOR THE TAGS


AWS_PROFILE=XXXXX

echo "${YELLOW} Validating local SAM Template..."
echo " ================================================= ${NC}"
sam validate --profile $AWS_PROFILE --template "template.yaml"


echo "${YELLOW} Package"
echo " ================================================= ${NC}"
sam package --profile $AWS_PROFILE --template-file ./template.yaml --output-template-file packaged-template.yaml --s3-bucket $BUCKET

echo "${YELLOW} Deploy"
echo " ================================================= ${NC}"
sam deploy --profile $AWS_PROFILE --region us-east-1 --template-file packaged-template.yaml --stack-name $STACK --tags Project=$PROJECT --parameter-overrides CertArn=$CERTARN ProjectId=$PROJECT Domain=$DOMAIN SubDomain=$SUBDOMAIN --capabilities CAPABILITY_NAMED_IAM


echo "${YELLOW} Desrcibe Stack"
echo " ===============${NC}"

CLOUDFRONT_DISTRIBUTION=`aws cloudformation describe-stacks --profile $AWS_PROFILE --region us-east-1 --stack-name "$STACK" --output text | grep $STACK-PortalDistribution | awk -F"\t" '{$0=$5}6'`
# Deploy to AWS S3

echo "${YELLOW} Deploy to S3 FE"
echo " ===============${NC}"

aws s3 sync dist/ s3://$SUBDOMAIN.$DOMAIN/  --acl public-read --profile $AWS_PROFILE --cache-control max-age=3600

echo "${YELLOW} Creating Invalidation "
echo " ===================== ${NC}"
aws cloudfront create-invalidation --profile $AWS_PROFILE --distribution-id $CLOUDFRONT_DISTRIBUTION --path "/*"