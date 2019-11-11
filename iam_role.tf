data "aws_iam_role" "ecs-role" {
  name = "ecsInstanceRole"
  #arn = "arn:aws:iam::141719373770:role/ecsInstanceRole"

}

data "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  #role = "${data.aws_iam_role.ecs-role.name}"
}

#data "aws_iam_instance_profile" "test_profile" {
  #name = "test_profile"
#}