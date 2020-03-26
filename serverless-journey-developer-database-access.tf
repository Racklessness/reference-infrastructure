resource "aws_security_group_rule" "allow_rds_local_access" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = [
    "79.140.115.93/32", # Chris's home internet
  ]
  security_group_id = data.aws_db_instance.serverless-journey-db.vpc_security_groups[0]
}