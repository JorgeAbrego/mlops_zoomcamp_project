# RDS Subnet Group
resource "aws_db_subnet_group" "private_db_subnet" {
  name        = "pg-rds-private-subnet-group"
  description = "Private subnet for RDS instance"
  subnet_ids  = ["${aws_subnet.private_subnet_a.id}", "${aws_subnet.private_subnet_b.id}"]
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-rds-sg"
  description = "Allow inbound/outbound Postgres traffic"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]
}

# Allow inbound Postgres connections
resource "aws_security_group_rule" "allow_pg_in" {
  description              = "Allow inbound Postgres connections"
  type                     = "ingress"
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.default.id
  security_group_id        = aws_security_group.rds_sg.id
}

# RDS Instance
resource "aws_db_instance" "postgres" {
  # Storage for instance in gigabytes
  allocated_storage = 10
  # The name of the RDS instance
  identifier = "mlops-tf-db"
  # See storage comparision https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#storage-comparison
  storage_type = "gp2"
  # Specific Relational Database Software https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html#Welcome.Concepts.DBInstance
  engine = "postgres"
  # InvalidParameterCombination: RDS does not support creating a DB instance with the following combination: DBInstanceClass=db.t4g.micro, Engine=mysql, EngineVersion=5.7.41,
  # https://aws.amazon.com/about-aws/whats-new/2021/09/amazon-rds-t4g-mysql-mariadb-postgresql/
  engine_version = "15.3"
  # See instance pricing https://aws.amazon.com/rds/mysql/pricing/?pg=pr&loc=2
  instance_class = "db.t3.micro"
  multi_az       = false
  db_name        = "mlflow_db"
  username       = "mlopspg"
  password       = "mlopspass"
  # Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group.
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet.name
  # Error: final_snapshot_identifier is required when skip_final_snapshot is false
  skip_final_snapshot = true
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]
}