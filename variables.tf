variable "server_port" {
    description = "The port the server for ssh session "
    default = 22

}

variable "key_name" {
  description = "A generated ssh_key pair"
  default = "ubuntu-key"
}