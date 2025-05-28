resource "aws_ecs_service" "retail" {
  //for_each = { for image in var.images : image.name => image } // this is looping on all images, for now its comment to only deploy only service (one deploy, one project)

  name            = "retail-php" //each.value.name
  cluster         = aws_ecs_cluster.retail.id
  task_definition = "ambit-retail-php-task:1" //each.value.task_definition
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

}
