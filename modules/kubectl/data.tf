data "template_file" "kubernetes_bastion_kubectl" {
  template = "${file("${path.module}/data/k8s_bastion_kubectl.tpl")}"

  vars {
    TLS_DIR_PATH = "${var.tls_data_dir}"
    CLUSTER_PUBLIC_ADDRESS = "${var.kubernetes_public_address}"
  }
}