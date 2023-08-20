# S3 Bucket to store MLflow Artifacts
resource "aws_s3_bucket" "mlflow_artifacts" {
  bucket = "jvaa-mlflow-artifacts"
}