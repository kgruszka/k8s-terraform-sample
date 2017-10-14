module "vpc" {
  source = "modules/vpc/"

  region = "${var.region}"
  availability_zone = "${var.availability_zone}"
  bastion_ami = "${var.bastion_ami}"
  bastion_public_key = "${var.cluster_public_key}"
  bastion_user = "ubuntu"
  bastion_private_key_path = "${var.cluster_private_key_path}"
  app_tag = "${var.app_tag}"
}

module "kubernetes" {
  source = "modules/cluster"
  region = "${var.region}"
  bastion_ip = "${module.vpc.bastion_public_ip}"

  cluster_public_key = "${var.cluster_public_key}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"

  # manager
  manager_ami = "${var.manager_ami}"
  manager_instance_type = "t2.micro"
  manager_count = "1"
  manager_security_group_id = "${module.vpc.kubernetes_manager_security_group_id}"
  manager_elb_security_group_id = "${module.vpc.kubernetes_manager_elb_security_group_id}"

  # worker
  worker_ami = "${var.worker_ami}"
  worker_instance_type = "t2.micro"
  worker_count = "1"
  worker_security_group_id = "${module.vpc.kubernetes_worker_security_group_id}"
  worker_elb_security_group_id = "${module.vpc.kubernetes_worker_elb_security_group_id}"

  # networking
  subnet_id = "${module.vpc.kubernetes_subnet_id}"
  subnet_cidr = "${module.vpc.kubernetes_subnet_cidr}"
  pod_cidr = "${module.vpc.kubernetes_pod_cidr}"
  kubernetes_route_table_id = "${module.vpc.kubernetes_route_table_id}"


  app_tag = "${var.app_tag}"

}

module "kubectl" {
  source = "modules/kubectl"
  kubernetes_public_address = "${module.kubernetes.kubernetes_manager_public_ips[0]}"
  tls_data_dir = "modules/cluster/tls/data"
}
//
//module "etcd_cluster" {
//  source = "modules/etcd/"
//
//  region = "${var.region}"
//  node_count = 3
//
//  bastion_public_ip = "${module.vpc.bastion_public_ip}"
//  cluster_token = "${var.etcd_cluster_token}"
//  public_key = "${var.cluster_public_key}"
//  private_key_path = "${var.cluster_private_key_path}"
//  subnet_id = "${module.vpc.kubernetes_subnet_id}"
//  security_group_id = "${module.vpc.kubernetes_etcd_security_group_id}"
//  app_tag = "${var.app_tag}"
//}

output "bastion_public_ip" {
  value = "${module.vpc.bastion_public_ip}"
}

output "kubernetes_manager_private_ips" {
  value = "${module.kubernetes.manager_private_ips}"
}

output "kubernetes_manager_public_ips" {
  value = "${module.kubernetes.kubernetes_manager_public_ips}"
}

output "kubernetes_worker_private_ips" {
  value = "${module.kubernetes.worker_private_ips}"
}

output "kubernetes_manager_elb_dns_name" {
  value = "${module.kubernetes.kubernetes_manager_elb_dns_name}"
}

output "kubernetes_worker_elb_dns_name" {
  value = "${module.kubernetes.kubernetes_worker_elb_dns_name}"
}