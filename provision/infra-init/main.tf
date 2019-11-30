data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_s3_bucket" "TfStateBucket" {
  bucket = "${var.bucket_name}"
  region = "${data.aws_region.current.name}"

  tags = {
    Project = "Alexa Airly Status"
    Name    = "${var.bucket_name}"
    Purpose = "Keep tfstate files"
  }
}

resource "aws_dynamodb_table" "TfStateTable" {
  name         = "${var.table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project = "Alexa Airly Status"
    Name    = "${var.table_name}"
    Purpose = "Keep tfstate files"
  }
}

resource "aws_iam_role" "TravisAlexaAirlyRole" {
  name        = "iam-role-for-travis-alexa-airly"
  path        = "/alexa-airly"
  description = "IAM role for Travis execution, created by terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Project = "Alexa Airly Status"
    Name = "TravisAlexaAirlyRole"
    Purpose = "Keep tfstate files"
  }
}

resource "aws_iam_policy" "TravisAlexaAirlyPolicy" {
  name = "iam-policy-for-travis-alexa-airly"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.ArtifactsBucket.arn}",
                   "${aws_s3_bucket.TfStateBucket.arn}"
                  ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.TfStateBucket.arn}/*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": ["${aws_s3_bucket.ArtifactsBucket.arn}/*",
                   "${aws_s3_bucket.TfStateBucket.arn}/*"
                  ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": ["arn:aws:dynamodb:*:*:table/${var.table_name}"]
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "TravisAlexaAttachement" {
  role       = "${aws_iam_role.TravisAlexaAirlyRole.name}"
  policy_arn = "${aws_iam_policy.TravisAlexaAirlyPolicy.arn}"
}

resource "aws_iam_user" "CodeDeployLambda" {
  name = "CodeDeployLambdaAlexaAirly"
  path = "/alexa-airly"

  tags = {
    Project = "Alexa Airly Status"
    Name    = "CodeDeployLambdaAlexaAirly"
    Purpose = "Service user for Lambda deployments"
  }
}
