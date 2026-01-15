data "aws_iam_policy_document" "ec2_s3_bucket_scoped" {
  # Erlaubt "aws s3 ls s3://<bucket>" (LIST auf Bucket-Ebene)
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.lab.arn
    ]
  }

  # Erlaubt Lesen/Schreiben in diesem Bucket (Objekt-Ebene)
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.lab.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_s3_bucket_scoped" {
  name   = "${var.name_prefix}-s3-bucket-scoped"
  policy = data.aws_iam_policy_document.ec2_s3_bucket_scoped.json
}

resource "aws_iam_role_policy_attachment" "ec2_s3_bucket_scoped" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_s3_bucket_scoped.arn
}
