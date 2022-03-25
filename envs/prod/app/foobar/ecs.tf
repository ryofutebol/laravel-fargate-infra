resource "aws_ecs_cluster" "this" {
  name = "${local.name_prefix}-${local.service_name}"

  # ECSタスクを実行するインフラを指定
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  tags = {
    Name = "${local.name_prefix}-${local.service_name}"
  }
}

# タスク定義
#resource "aws_ecs_task_definition" "this" {
#  # タスク定義名
#  family = "${local.name_prefix}-${local.service_name}"
#
#  task_role_arn = aws_iam_role.ecs_task.arn
#
#  # Fargateタイプはawsvpc
#  network_mode = "awsvpc"
#
#  # ECSの起動タイプ
#  requires_compatibilities = [
#    "FARGATE",
#  ]
#  # タスク実行ロール
#  execution_role_arn = aws_iam_role.ecs_task_execution.arn
#
#  # スペック
#  memory = "512"
#  cpu    = "256"
#
#  # 各コンテナの設定
#  container_definitions = jsonencode(
#    [
#      {
#        name  = "nginx"
#        image = "${module.nginx.ecr_repository_this_repository_url}:latest"
#
#        portMappings = [
#          {
#            containerPort = 80
#            protocol      = "tcp"
#          }
#        ]
#
#        environment = []
#        secrets     = []
#
#        dependsOn = [
#          {
#            containerName = "php"
#            condition     = "START"
#          }
#        ]
#
#        mountPoints = [
#          {
#            containerPath = "/var/run/php-fpm"
#            sourceVolume  = "php-fpm-socket"
#          }
#        ]
#
#        logConfiguration = {
#          logDriver = "awslogs"
#          options = {
#            awslogs-group         = "/ecs/${local.name_prefix}-${(local.service_name)}/nginx"
#            awslogs-region        = data.aws_region.current.id
#            awslogs-stream-prefix = "ecs"
#          }
#        }
#      },
#      {
#        name  = "php"
#        image = "${module.php.ecr_repository_this_repository_url}:latest"
#
#        portMappings = []
#
#        environment = []
#        # パラメータストアの値を環境変数として渡す
#        secrets = [
#          {
#            name      = "APP_KEY"
#            valueFrom = "/${local.system_name}/${local.env_name}/${local.service_name}/APP_KEY"
#          }
#        ]
#
#        mountPoints = [
#          {
#            containerPath = "/var/run/php-fpm"
#            sourceVolume  = "php-fpm-socket"
#          }
#        ]
#
#        # CloudWatchログを出力する
#        logConfiguration = {
#          logDriver = "awslogs"
#          options = {
#            awslogs-group         = "/ecs/${local.name_prefix}-${(local.service_name)}/php"
#            awslogs-region        = data.aws_region.current.id
#            awslogs-stream-prefix = "ecs"
#          }
#        }
#      }
#    ]
#  )
#
#  volume {
#    name = "php-fpm-socket"
#  }
#
#  tags = {
#    Name = "${local.name_prefix}-${local.service_name}"
#  }
#}

#resource "aws_ecs_service" "this" {
#  # ECSサービス名
#  name = "${local.name_prefix}-${local.service_name}"
#
#  # 属するクラスター
#  cluster = aws_ecs_cluster.this.arn
#
#  capacity_provider_strategy {
#    capacity_provider = "FARGATE_SPOT"
#    base              = 0
#    weight            = 1
#  }
#  platform_version = "1.4.0"
#
#  task_definition = aws_ecs_task_definition.this.arn
#
#  # 起動させておくタスク数
#  desired_count                      = var.desired_count
#  deployment_minimum_healthy_percent = 100
#  deployment_maximum_percent         = 200
#
#  load_balancer {
#    container_name   = "nginx"
#    container_port   = 80
#    target_group_arn = data.terraform_remote_state.routing_app_link.outputs.lb_target_group_foobar_arn
#  }
#
#  health_check_grace_period_seconds = 60
#
#  network_configuration {
#    assign_public_ip = false
#    security_groups = [
#      data.terraform_remote_state.network_main.outputs.security_group_vpc_id
#    ]
#    subnets = [
#      for s in data.terraform_remote_state.network_main.outputs.subnet_private : s.id
#    ]
#  }
#
#  enable_execute_command = true
#
#  tags = {
#    Name = "${local.name_prefix}-${local.service_name}"
#  }
#}