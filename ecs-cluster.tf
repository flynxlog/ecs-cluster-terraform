resource "aws_ecs_cluster" "ecs-example" {
  name = "ecs-demo-ss"

  tags {
    Name = "ecs-demo-ss"

  }
}


resource "aws_instance" "ecs-agent" {
  #ami = "ami-0f846c06eb372f19a"
  #ami = "ami-00eb20669e0990cb4"
  ami  = "ami-0c65e6401a50512c5" #ecs- optimized
  count = "2"
  instance_type = "t2.micro"
  iam_instance_profile = "${data.aws_iam_instance_profile.test_profile.name}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  #subnet_id = "${data.aws_subnet_ids.default.vpc_id}"
  key_name      = "testkey"



  user_data = <<-EOF
             #!/bin/bash
             mkdir -p /etc/ecs
             touch /etc/ecs/ecs.config
             echo "ECS_CLUSTER=ecs-demo-ss" >> /etc/ecs/ecs.config
             EOF

  ebs_block_device {
    device_name = "/dev/xvda"
    #snapshot_id = "snap-0fac6541adee434a9"
    volume_size =  30
  }

  tags {
    Name = "ecs-test"

  }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port = "${var.server_port}"
        to_port  = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    # TLS (change to whatever ports you need)
    from_port = 0
    to_port   = 0
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


