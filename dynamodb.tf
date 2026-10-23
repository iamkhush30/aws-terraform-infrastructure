resource "aws_dynamodb_table" "my_app_table" {
  name         = "${var.my_environment}-km-cloud-app-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.my_environment}-km-cloud-app-table"
    Environment = var.my_environment
  }
}
