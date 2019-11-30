variable "region" {
  type        = "string"
  description = "Default region"
}

variable "bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket, where state files will be stored"
}

variable "table_name" {
  type        = "string"
  description = "Name of the DynamoDB table, where locks will be written"
}
