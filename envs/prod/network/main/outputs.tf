output "security_group_web_id" {
  value = aws_security_group.web.id
}

output "security_group_vpc_id" {
  value = aws_security_group.vpc.id
}

output "security_group_db_foobar_id" {
  value = aws_security_group.db_foobar.id
}

output "security_group_cache_foobar_id" {
  value = aws_security_group.cache_foobar.id
}

output "subnet_public" {
  # 複数存在する可能性があるため後でIDだけ取り出す
  value = aws_subnet.public
}

output "subnet_private" {
  value = aws_subnet.private
}

output "vpc_this_id" {
  value = aws_vpc.this.id
}

output "db_subnet_group_this_id" {
  value = aws_db_subnet_group.this.id
}

output "elasticache_subnet_group_this_name" {
  value = aws_elasticache_subnet_group.this.name
}