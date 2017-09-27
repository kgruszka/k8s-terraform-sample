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