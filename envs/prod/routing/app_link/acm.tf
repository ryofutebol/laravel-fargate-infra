resource "aws_acm_certificate" "root" {
  # 発行する証明書のドメイン
  domain_name = data.aws_route53_zone.this.name

  # ドメインの所有権の検証
  validation_method = "DNS"

  tags = {
    Name = "${local.name_prefix}-app-link"
  }


  lifecycle {
    # 新しいリソースを作成してから古いリソースを削除する
    create_before_destroy = true
  }
}

# DNS検証を行う
#resource "aws_acm_certificate_validation" "root" {
#  certificate_arn = aws_acm_certificate.root.arn
#}