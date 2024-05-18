terraform {
  backend "s3" {
    bucket = "terraform-backend-test-task"
    key    = "production/terraform.tfstate" 
    region = "us-west-2" 
    encrypt = true
  }
}




