# Terraform Docker build and ECR push module

Forked from [onnimonni/terraform-ecr-docker-build-module](https://github.com/sidthakur/terraform-ecr-docker-build-module)

Extended to add support for separate docker build context, specific Dockerfile and enable/disable for local integration
testing.

## Requirements

Terraform version needs to be 0.12 or newer.

You need to have following programs installed in your $PATH:

* bash
* md5sum or md5
* aws
* docker
* tar

**Note:** Docker server needs to be running so that we can actually build images

## AWS Credentials
You need to provide AWS credentials as env or profile for aws-cli for this module to work properly

## Example
```hcl
# Reference existing ECR repository
data "aws_ecr_repository" "test_service" {
  name = "example-service"
}

# Build Docker image and push to ECR from folder: ./example-service-directory
module "ecr_docker_build" {
  source = "github.com/sidthakur/terraform-ecr-docker-build-module"

  # Absolute path into the service which needs to be build
  docker_build_context_dir = "${path.module}/example-service-directory"
  
  # Absolute path to the Dockerfile
  docker_build_context_dir = "${path.module}/example-service-directory/Dockerfile"

  # Tag for the Docker image being built (Defaults to 'latest')
  docker_image_tag = "development"
  
  # The region which we will log into with aws-cli
  aws_region = "eu-west-1"

  # ECR repository where we can push
  ecr_repository_url = data.aws_ecr_repository.test_service.repository_url
  
  # Set local integration testing to true
  local_integration_testing = true
}
```

## License
MIT

## Author
[Onni Hakala](https://github.com/onnimonni)
[Siddharth Thakur](https://github.com/sidthakur)
