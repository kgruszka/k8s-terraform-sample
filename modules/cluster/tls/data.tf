resource "null_resource" "tls" {
  provisioner "local-exec" {
    command = "sh ${path.module}/data/generate.sh ${var.worker_public_ips} ${var.worker_private_ips} ${var.manager_private_ips} ${var.manager_public_address}"
  }
}

data "template_file" "kubernetes_worker_ca_pem" {
  depends_on = ["null_resource.tls"]

  template = "${file("${path.module}/data/ca.pem")}"
}

data "template_file" "kubernetes_worker_instance_key_pem" {
  depends_on = ["null_resource.tls"]
  count = "${var.worker_count}"

  template = "${file("${path.module}/data/worker-${count.index}-key.pem")}"
}

data "template_file" "kubernetes_worker_instance_pem" {
  depends_on = ["null_resource.tls"]
  count = "${var.worker_count}"

  template = "${file("${path.module}/data/worker-${count.index}.pem")}"
}

data "template_file" "kubernetes_manager_ca_pem" {
  depends_on = ["null_resource.tls"]

  template = "${file("${path.module}/data/ca.pem")}"
}

data "template_file" "kubernetes_manager_ca_key_pem" {
  depends_on = ["null_resource.tls"]

  template = "${file("${path.module}/data/ca-key.pem")}"
}

data "template_file" "kubernetes_manager_kubernetes_key_pem" {
  depends_on = ["null_resource.tls"]

  template = "${file("${path.module}/data/kubernetes-key.pem")}"
}

data "template_file" "kubernetes_manager_kubernetes_pem" {
  depends_on = ["null_resource.tls"]

  template = "${file("${path.module}/data/kubernetes.pem")}"
}

output "kubernetes_worker_ca_pem" {
  value = "${data.template_file.kubernetes_worker_ca_pem.rendered}"
}

output "kubernetes_worker_instance_key_pem" {
  value = "${data.template_file.kubernetes_worker_instance_key_pem.*.rendered}"
}

output "kubernetes_worker_instance_pem" {
  value = "${data.template_file.kubernetes_worker_instance_pem.*.rendered}"
}

output "kubernetes_manager_ca_pem" {
  value = "${data.template_file.kubernetes_manager_ca_pem.rendered}"
}

output "kubernetes_manager_ca_key_pem" {
  value = "${data.template_file.kubernetes_manager_ca_key_pem.rendered}"
}

output "kubernetes_manager_kubernetes_key_pem" {
  value = "${data.template_file.kubernetes_manager_kubernetes_key_pem.rendered}"
}

output "kubernetes_manager_kubernetes_pem" {
  value = "${data.template_file.kubernetes_manager_kubernetes_pem.rendered}"
}