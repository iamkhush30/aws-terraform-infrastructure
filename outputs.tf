output "ec2_arn" {
  description = "ARNs of the EC2 instances"
  value       = aws_instance.my_instance[*].arn
}

output "ec2_public_ip" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.my_instance[*].public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.testbucket.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.my_app_table.name
}
