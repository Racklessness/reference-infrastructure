resource "aws_db_instance" "serverless-journey-db" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mariadb"
  engine_version = "10.3"
  instance_class = "db.t2.micro"
  name = "serverless"
  // TODO this definitely needs to change. We don't want to be creating this stuff in plain text.
  username = "serverless"
  password = "serverless"
  parameter_group_name = "default.mariadb10.3"
  // Publicly accessible here doesn't mean you can reach it, just that external traffic is allowed.
  // You still need to configure the security group for the database VPC to accept traffic
  publicly_accessible = true
}

/**
 * The output of the database instance does not contain the security groups associated with the
 * instance, and we need these to update the inbound rules if developers want to request local
 * access or if we need to add some rules for automation etc.
 */
data "aws_db_instance" "serverless-journey-db" {
  db_instance_identifier = aws_db_instance.serverless-journey-db.id
}