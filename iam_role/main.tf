variable "name" {}
variable "policy" {}
variable "identifier" {}

# １．ロールの定義
resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

}

# １．１ロール用の信頼ポリシードキュメント
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]

    }
  }
}

# カスタマ管理ポリシーの定義
resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy

}

# ロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "default" {
  role        = aws_iam_role.default.name
  policy_arn  = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}


output "iam_role_name" {
  value = aws_iam_role.default.name
}
