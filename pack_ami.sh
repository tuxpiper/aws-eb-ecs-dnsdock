#!/bin/bash

get_ami() {
  local region=$1;
  case "$region" in
    us-east-1)
      echo "ami-a8bab1c2";    # aws-elasticbeanstalk-amzn-2016.03.0.x86_64-ecs-hvm-201603311132
      ;;
    *)
      echo "ERROR: unknown region $region" 1>&2;
      exit 1
      ;;
  esac
}

# determine region
region=${1:-$AWS_DEFAULT_REGION}

# get source ami for region
source_ami=`get_ami $region`

# build it
packer build \
  -var "aws_region=$region" \
  -var "source_ami=$source_ami" \
  -var "aws_access_key_id=$AWS_ACCESS_KEY_ID" \
  -var "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" \
  ecs_dnsdock.json
