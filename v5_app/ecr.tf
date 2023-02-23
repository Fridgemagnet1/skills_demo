resource "aws_ecr_repository" "docker_repo" {
  name                 = "docker-test"
  image_tag_mutability = "MUTABLE"

  tags = {
    project = "hello-world"
  }
}
