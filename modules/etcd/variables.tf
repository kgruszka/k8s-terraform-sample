variable "region" {}
variable "node_count" {}
variable "ami" {
  default = "ami-4fffc834"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ec2_user" {
  default = "ec2-user"
}
variable "bastion_public_ip" {}
variable "public_key" {}
variable "private_key_path" {}
variable "cluster_token" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "app_tag" {}