data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = local.lambda_zip_path
}

resource "aws_lambda_function" "app" {
  function_name = var.project_name
  role          = aws_iam_role.lambda_role.arn

  runtime = "python3.11"
  handler = "handler.handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout     = 10
  memory_size = 128
}
