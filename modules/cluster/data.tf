data "template_file" "pod_cidr" {
  count = "${aws_instance.kubernetes_worker.count}"
  template = "${file("${path.module}/data/pod-cidr.tpl")}"

  vars {
    POD_CIDR = "${cidrsubnet(var.pod_cidr, 0, count.index)}"
  }
}