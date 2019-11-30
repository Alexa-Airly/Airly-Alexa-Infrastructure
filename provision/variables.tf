variable "region" {
  type        = "string"
  description = "Default region"
}

variable "bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket, where state files will be stored"
}

variable "artifacts_bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket, where artifacts will be stored"
}

variable "table_name" {
  type        = "string"
  description = "Name of the DynamoDB table, where locks will be written"
}

variable "airly_table_name" {
  type        = "string"
  description = "Name of DynamoDB table, where Airly data will be stored"
}
