data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_s3_bucket" "ArtifactsBucket" {
  bucket = "${var.artifacts_bucket_name}"
  region = "${data.aws_region.current.name}"

  tags = {
    Project = "Alexa Airly Status"
    Name    = "${var.artifacts_bucket_name}"
    Purpose = "Keeping data for code deploy"
  }
}

resource "aws_dynamodb_table" "AirlyTable" {
  name         = "${var.airly_table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ContextElement"

  attribute {
    name = "ContextElement"
    type = "S"
  }

  tags = {
    Project = "Alexa Airly Status"
    Name    = "${var.airly_table_name}"
    Purpose = "Keep history and config"
  }
}


