provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "${var.environment}"
      Service     = "mlops-service"
      CreatedBy   = "terraform"
    }
  }
}