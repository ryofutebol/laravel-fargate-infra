resource "aws_lb" "this" {
  # リソースの数
  count = var.enable_alb ? 1 : 0

  name = "${local.name_prefix}-appfoobar-link"

  # インターネットプケロードバランサー
  internal = false
  # ALB
  load_balancer_type = "application"

  # アクセスログをS3に保存
  access_logs {
    bucket  = data.terraform_remote_state.log_alb.outputs.s3_bucket_this_id
    enabled = true
    prefix  = "app-link"
  }

  security_groups = [
    data.terraform_remote_state.network_main.outputs.security_group_web_id,
    data.terraform_remote_state.network_main.outputs.security_group_vpc_id
  ]

  subnets = [
    for s in data.terraform_remote_state.network_main.outputs.subnet_public : s.id
  ]

  tags = {
    Name = "${local.name_prefix}-appfoobar-link"
  }
}

resource "aws_lb_listener" "https" {
  count = var.enable_alb ? 1 : 0

  # 証明書のARN
  certificate_arn = aws_acm_certificate.root.arn
  # リスナーに紐づくALB
  load_balancer_arn = aws_lb.this[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  # リクエストを受け付けたときのデフォルトのアクション
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.foobar.arn
    #    type = "fixed-response"
    #    fixed_response {
    #      content_type = "text/plain"
    #      message_body = "Fixed response content"
    #      status_code  = "200"
    #    }
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  # デフォルトをHTTPSにリダイレクトとする
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "foobar" {
  name = "${local.name_prefix}-foobar"

  # ALBから切り離す前にALBが待機する時間
  deregistration_delay = 60
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.network_main.outputs.vpc_this_id
  # ターゲットに対してのヘルスチェック
  health_check {
    # 連続成功回数
    healthy_threshold = 2
    # ヘルスチェックの感覚
    interval = 30
    # 正常とみなすステータスコード
    matcher  = 200
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
    timeout  = 5
    # 異常とみなす連続失敗回数
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${local.name_prefix}-foobar"
  }
}