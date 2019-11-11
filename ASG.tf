resource "aws_launch_configuration" "example" {
    #image_id  = "ami-00eb20669e0990cb4" #ECS agent
    image_id = "ami-0c65e6401a50512c5"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
               mkdir -p /etc/ecs
               touch /etc/ecs/ecs.config
               echo "ECS_CLUSTER=ecs-demo-ss" >> /etc/ecs/ecs.config
            EOF

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.name}"
    vpc_zone_identifier = ["${data.aws_subnet_ids.default.ids}"]

    min_size = 2
    max_size = 2

    tag{
        key   = "Name"
        value  = "ecs-test"
        propagate_at_launch = true
    }

}
