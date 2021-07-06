#!/bin/bash

# Fail fast
set -e

# This is the order of arguments
docker_build_context_dir=$1
dockerfile_loc=$2
aws_ecr_repository_url_with_tag=$3
# Enable/disable local integration testing mode with localstack
local_integration_testing=$4
# kept for backwards compatibility
aws_region=$5

# Allow overriding the aws region from system
if [ "$aws_region" != "" ]; then
  aws_extra_flags="--region $aws_region"
else
  aws_extra_flags=""
fi

# Check that aws is installed
which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }

# Check that docker is installed and running
which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }

# Connect into aws
# If local_integration_testing is set to true, then skip authentication
if [ "$local_integration_testing" == "true" ]; then
  echo "Local integration testing mode. Skipping aws ecr authentication."
else
  aws ecr get-login-password $aws_extra_flags | docker login --username AWS --password-stdin \
                                                       $aws_ecr_repository_url_with_tag
fi

# Some Useful Debug
echo "Building $aws_ecr_repository_url_with_tag from $docker_build_context_dir using $dockerfile_loc"

# Build image
docker build -t $aws_ecr_repository_url_with_tag -f $dockerfile_loc $docker_build_context_dir

# Push image
docker push $aws_ecr_repository_url_with_tag