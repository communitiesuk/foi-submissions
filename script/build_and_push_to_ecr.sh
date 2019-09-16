#!/usr/bin/env bash

# Build and push all 3 docker images to ECR
# Requires the following env vars:
#
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
# Credentials for the IAM user which will assume the "CI" role to
# authenticate against the ECR registry
#
# CI_ROLE_ARN
# ARN of the CI role which the script will assume in order to authenticate
# against the ECR registry
#
# ECR_REGISTRY_URL
# URL of the ECR Docker registry to which the images will be pushed
# NOTE: Don't include any protocol part, just use hostname/path
# e.g. "12345678.ecr.eu-west-2.amazonaws.com/myregistryname"
#
# Optional variables:
#
# DEBUG
# If set to "true", outputs every command it executes (i.e. sets -x)
#
# APP_NAME
# Used as a prefix for the Docker image names. Defaults to "foi-submissions"
#
set -e
case $DEBUG in
  (true)  set -x;;
esac

APP_NAME=${APP_NAME:=foi-submissions}

function install_dependencies {
  # document the versions travis is using
  docker --version
  aws --version || pip install --user awscli # install aws cli w/o sudo
  jq --version
}

function assume_ci_role {
  json=$(aws sts assume-role --role-arn=${CI_ROLE_ARN} --role-session-name=with-ci-role --output=json)
  export ROLE_ACCESS_KEY_ID=$(echo $json | jq -r '.Credentials .AccessKeyId')
  export ROLE_SECRET_ACCESS_KEY=$(echo $json | jq -r '.Credentials .SecretAccessKey')
  export ROLE_SESSION_TOKEN=$(echo $json | jq -r '.Credentials .SessionToken')
}

function login_to_ecr {
  # needs the temporary AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY envvars
  # for the assumed role session

  # So we stash any existing values
  OLD_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
  OLD_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
  OLD_SESSION_TOKEN=${AWS_SESSION_TOKEN}

  # Export the new ones (so the values don't appear in command history or logs)
  export AWS_ACCESS_KEY_ID=${ROLE_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${ROLE_SECRET_ACCESS_KEY}
  export AWS_SESSION_TOKEN=${ROLE_SESSION_TOKEN}

  # Run the cmd
  eval $(aws ecr get-login --no-include-email --region eu-west-2)

  # Finally put the old values back
  export AWS_ACCESS_KEY_ID=${OLD_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${OLD_SECRET_ACCESS_KEY}
  export AWS_SESSION_TOKEN=${OLD_SESSION_TOKEN}

}

function build_and_push {
  suffix=$1
  image="${APP_NAME}-${suffix}"
  docker build -t ${image} -f docker/${suffix}/Dockerfile .
  docker tag ${image}:latest ${ECR_REGISTRY_URL}/${image}:latest
  docker push ${ECR_REGISTRY_URL}/${image}:latest

}

function main {
  echo "checking dependencies"
  install_dependencies
  echo "assuming the CI role ${CI_ROLE_ARN}"
  assume_ci_role
  echo "logging in to ECR at ${ECR_REGISTRY_URL}"
  login_to_ecr
  export PATH=$PATH:$HOME/.local/bin # put aws in the path

  for suffix in base web worker
  do
    echo "building & pushing ${suffix} to ${ECR_REGISTRY_URL}"
    build_and_push ${suffix}
  done
}

main
