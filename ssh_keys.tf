#resource "tls_private_key" "example" {
  #algorithm = "RSA"
  #rsa_bits  = 4096
#}

### public_key = "${tls_private_key.example.public_key_openssh}"
#}

#resource "aws_key_pair" "SS_KeyPair" {
  #key_name   = "SS_KeyPair"
 # public_key = "${file("awskey.pub")}"
#}

resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "Test_KeyPair"
  public_key = "${file("terraform_ec2_key.pub")}"
}
