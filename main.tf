provider "aws" {
  region     = "us-east-1"
  version    = "~>2.0"
  access_key = "AKIASB7ZCA7FAWNTQSFX"
  secret_key = "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"
}

resource "aws_ecs_cluster" "ecs-sitespeed" {
  name = "ecs-sitespeed-demo"


}
resource "aws_instance" "ecs-agent" {
  #ami = "ami-0f846c06eb372f19a"
  #ami = "ami-00eb20669e0990cb4"
  ami = "ami-0c65e6401a50512c5"

  #ecs- optimized
  #count = "2"
  instance_type = "t2.micro"

  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  vpc_security_group_ids = [
    "${aws_security_group.alb.id}",
  ]

  #subnet_id = "${data.aws_subnet_ids.default.vpc_id}"
  key_name = "testkey"

  user_data = <<-EOF
             #!/bin/bash
             mkdir -p /etc/ecs
             touch /etc/ecs/ecs.config
             echo "ECS_CLUSTER=ecs-sitespeed-demo" >> /etc/ecs/ecs.config
             EOF

  tags {
    Name = "ss-ecs-test"
  }
}

