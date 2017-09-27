variable "region" {}
variable "availability_zone" {}
variable "bastion_ami" {}
variable "bastion_instance_type" {
  default = "t2.micro"
}
variable "bastion_public_key" {}
variable "bastion_user" {}
variable "bastion_private_key_path" {}
variable "app_tag" {}