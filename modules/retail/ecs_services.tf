resource "aws_ecs_service" "retail" {
  //for_each = { for image in var.images : image.name => image } // this is looping on all images, for now its comment to only deploy only service (one deploy, one project)

  name            = "retail-billing-php" //each.value.name
  cluster         = aws_ecs_cluster.retail.id
  task_definition = "ambit-retail-php-task:4" //each.value.task_definition
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:264272770386:targetgroup/tg-retail/fbc0cc131eb37e0e"
    container_name   = "retail-billing-php"  # Must match container name in task definition
    container_port   = 80            # Must match port container is exposing
  }

}//duplicate this step instead of removing the old one check with jorge and use only one command to deploy all with depends on
