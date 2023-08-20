# EC2 Instance
resource "aws_instance" "mlops-platform" {
  # https://cloud-images.ubuntu.com/locator/ec2/
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_a.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.default.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp2"
  }
  tags = {
    Name = "mlops-platform"
    OS   = "ubuntu"
  }

  depends_on = [aws_security_group.default, aws_key_pair.ec2_key_pair]

  user_data = base64encode(templatefile("user_data.sh", {
    DB_USER = aws_db_instance.postgres.username
    DB_PASS = aws_db_instance.postgres.password
    DB_HOST = aws_db_instance.postgres.address
    DB_PORT = aws_security_group_rule.allow_pg_in.from_port
    DB_NAME = aws_db_instance.postgres.db_name
  }))
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generates a local file 
# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file 
resource "local_sensitive_file" "tf_key" {
  content              = tls_private_key.rsa.private_key_pem
  file_permission      = "600"
  directory_permission = "700"
  filename             = "${aws_key_pair.ec2_key_pair.key_name}.pem"
}
