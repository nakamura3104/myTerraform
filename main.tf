r/leE5JbSTBNfAEl6VjRHT9uMrrvfcbwMT5N3Q/tPpQ=


[Interface]
PrivateKey = <YOUR_PRIVATE_KEY>
Address = 10.64.3.204/32

[Peer]
PublicKey = woha3spWgVr2luPW/8J0OLlP2Csh7r7qu9Umyh7x4Hg=
AllowedIPs = 100.127.0.0/21, 100.127.10.0/28, 100.127.10.128/25, 100.127.10.17/32, 100.127.10.18/31, 100.127.10.20/30, 100.127.10.24/29, 100.127.10.32/27, 100.127.10.64/26, 100.127.11.0/24, 100.127.12.0/22, 100.127.128.0/17, 100.127.16.0/20, 100.127.32.0/19, 100.127.64.0/18, 100.127.8.0/23, 54.250.252.67/32
Endpoint = beck.arc.soracom.io:11010


module "describe_regions_for_ec2" {
  source     = "./iam_role"
  name       = "describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
}


# カスタマー管理ポリシー用の用のポリシードキュメント
data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeReagions"] # リージョン一覧を取得する
    resources = ["*"]
  }
}

resource "aws_s3_bucket" "private" {
  bucket = "private-satoshi-terraform-on-aws"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "public" {
  bucket = "public-satoshi-terraform-on-aws"
  acl    = "public-read"

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-satoshi-nakamura-0220"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}


# テストのコメント
data "aws_iam_policy_document" "alb_log" {

  statement {
    effect   = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]

    }
  }
}
