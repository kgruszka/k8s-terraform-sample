variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "bastion_ami" {}
variable "manager_ami" {}
variable "worker_ami" {}

variable "cluster_user" {}
variable "cluster_public_key" {}
variable "cluster_private_key_path" {}

variable "etcd_cluster_token" {}

variable "app_tag" {
  default = "kubernetes-sample"
}