# configure the AWS provider using the shared credentials
provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
  shared_credentials_file = "/home/jlynx/.aws/credentials"
}

