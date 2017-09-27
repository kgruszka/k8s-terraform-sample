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
  count = "${aws_instance.kubernetes_worker.count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_worker.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "file" {
    content = "${data.template_file.pod_cidr.rendered}"
    destination = "/etc/pod_cidr"
  }
}