# Checks if build folder has changed
data "external" "build_folder" {
  program = ["${path.module}/bin/folder_contents.sh", var.docker_build_context_dir]
}

# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "build_and_push" {
  triggers = {
    build_folder_content_md5 = data.external.build_folder.result.md5
  }

  # See build.sh for more details
  provisioner "local-exec" {
    command = <<EOL
    ${path.module}/bin/build.sh ${var.docker_build_context_dir} \
                                ${var.dockerfile_loc} \
                                ${var.ecr_repository_url}:${var.docker_image_tag} \
                                ${var.local_integration_testing} \
                                ${var.aws_region}
    EOL
  }
}

