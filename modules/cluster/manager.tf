resource "aws_instance" "kubernetes_manager" {
  count = "${var.manager_count}"
  ami = "${var.manager_ami}"
  instance_type = "${var.manager_instance_type}"
  key_name = "${aws_key_pair.kubernetes.key_name}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  private_ip = "${cidrhost(var.subnet_cidr, 10 + count.index)}"

  vpc_security_group_ids = ["${var.manager_security_group_id}"]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes manager"
  }
}

output "manager_private_ips" {
  value = "${aws_instance.kubernetes_manager.*.private_ip}"
}

resource "null_resource" "control_plane" {
  depends_on = [
    "null_resource.kubernetes_manager_tls",
    "null_resource.etcd"
  ]
  count = "${var.manager_count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "file" {
    content = "${element(data.template_file.k8s_manager_init.*.rendered, count.index)}"
    destination = "/home/${var.cluster_user}/control_plane_init.sh"
  }

  provisioner "file" {
    content = "${file("${path.module}/data/cluster_role.yml")}"
    destination = "/home/${var.cluster_user}/cluster_role.yml"
  }

  provisioner "file" {
    content = "${file("${path.module}/data/cluster_role_binding.yml")}"
    destination = "/home/${var.cluster_user}/cluster_role_binding.yml"
  }

  provisioner "remote-exec" {
    inline = ["sudo sh control_plane_init.sh"]
  }
}

output "kubernetes_manager_public_ips" {
  value = "${aws_instance.kubernetes_manager.*.public_ip}"
}