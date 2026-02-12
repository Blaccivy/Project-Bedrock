output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "lambda_name" {
  value = aws_lambda_function.asset_processor.function_name
}
