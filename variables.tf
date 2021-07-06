variable "docker_build_context_dir" {
  type        = string
  description = "This is the dir which is passed to docker build as context, i.e. root from where docker build is run"
}

variable "dockerfile_loc" {
  type        = string
  description = "This is the path to specific Dockerfile being built"
}

variable "docker_image_tag" {
  type        = string
  description = "This is the tag which will be used for the image that you created"
  default     = "latest"
}

variable "aws_region" {
  type        = string
  description = "AWS region for ECR"
  default     = ""
}

variable "ecr_repository_url" {
  type        = string
  description = "Full url for the ecr repository"
}

variable "local_integration_testing" {
  type        = bool
  default     = false
  description = "Setting this flag to true will skip authentication and push the image to localstack ecr"
}