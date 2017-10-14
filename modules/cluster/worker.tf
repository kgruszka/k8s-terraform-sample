resource "aws_instance" "kubernetes_worker" {
  count = "${var.worker_count}"
  ami = "${var.worker_ami}"
  instance_type = "${var.worker_instance_type}"
  key_name = "${aws_key_pair.kubernetes.key_name}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  private_ip = "${cidrhost(var.subnet_cidr, 20 + count.index)}"

  vpc_security_group_ids = ["${var.worker_security_group_id}"]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes worker"
  }
}

resource "null_resource" "kubernetes_worker" {
  depends_on = ["null_resource.control_plane"]
  count = "${aws_instance.kubernetes_worker.count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_worker.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

//  provisioner "file" {
//    content = "${data.template_file.pod_cidr.rendered}"
//    destination = "/home/${var.cluster_user}/pod_cidr"
//  }

  provisioner "file" {
    content = "${data.template_file.k8s_worker_init.rendered}"
    destination = "/home/${var.cluster_user}/worker_init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh worker_init.sh"
    ]
  }
}

output "worker_private_ips" {
  value = "${aws_instance.kubernetes_worker.*.private_ip}"
}