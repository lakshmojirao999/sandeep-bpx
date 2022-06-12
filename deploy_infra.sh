#!/usr/bin/env bash
echo
# Environment Discovery

DEFAULT_ENVIRONMENT=dev
PROFILE=default
BUCKETNAME=cf-templates-1lbzbbs35uas-us-west-2

PROD_PROFILE=prod
PROD_BUCKETNAME=cf-templates-1lbzbbs35uas-us-west-2

ACTION=update


if [ -z "$1" ]
    then
        echo "No Environment Specified. Please choose: dev,qa,uat,prod"
        echo "Usage: deploy-infra.sh [ENVIRONMENT] [ACTION(create: Optional; default: update)]"
        exit 1
        # echo "No Environment Specified, using default environment: ${DEFAULT_ENVIRONMENT}"
        # ENVIRONMENT=${DEFAULT_ENVIRONMENT}
    else
        echo "Environment Specified, using environment: ${1}"
        ENVIRONMENT=${1}
        if [ "$ENVIRONMENT" == "prod" ]
            then
                echo "Prod Deployment Detected. Sleeping for 5."
                sleep 5
                echo "Proceeding with Prod Deployment"
                PROFILE=${PROD_PROFILE}
                BUCKETNAME=${PROD_BUCKETNAME}
        fi
fi

if [ "$2" == "create" ]
    then
        echo 'Creation Detected. Creating Stack.'
        ACTION=create
    else
        echo 'Default Update Action Detected. Updating.'
fi

sleep 2

echo
# Lamdb zip upload to s3
rm -rf cf/lambda/delVpc.zip

zip -r -j cf/lambda/delVpc.zip cf/lambda/delVpc.py
# Infrastructure
aws s3 sync cf s3://${BUCKETNAME}/${ENVIRONMENT}/cf --profile ${PROFILE} 
# Update devVPC Stack

aws cloudformation ${ACTION}-stack --stack-name delVpc-${ENVIRONMENT}-stack \
 --template-url https://s3.amazonaws.com/${BUCKETNAME}/${ENVIRONMENT}/cf/default_vpc_mgmt.yml --profile ${PROFILE} \
 --capabilities CAPABILITY_NAMED_IAM \
 --parameters file://./cf/params/cf-params.json 

