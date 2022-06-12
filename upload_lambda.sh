#!/bin/sh
# This script assumes the provided role and performs CLI actions
# Author: Lakshmoji Rao Yalamati <lakshmoji@saplinghr.com>
# Description: Uploading Lambda zip content to s3
ENVIRONMENT=${1}
region=$region
profile=default
BucketName=stgbpxdev-us-west-1

rm -rf cf/lambda/delVpc.zip

zip -r -j cf/lambda/delVpc.zip cf/lambda/delVpc.py

aws s3 --profile $profile  sync cf s3://$BucketName/$ENVIRONMENT