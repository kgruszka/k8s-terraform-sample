module "test" {
  source = "modules/test"
  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.kubernetes.manager_private_ips}"
  worker_machine_ips = "${module.kubernetes.worker_private_ips}"
  test_init_manager_dir_path = "test/init_manager"
  test_init_worker_dir_path = "test/init_worker"
  test_run_dir_path = "test/run"
}