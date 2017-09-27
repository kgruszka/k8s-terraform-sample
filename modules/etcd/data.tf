data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
  count = "${var.node_count}"

  vars {
    NAME = "${element(aws_instance.etcd_node.*.id, count.index)}"
    IP = "${element(aws_instance.etcd_node.*.public_ip, count.index)}"
    CLUSTER = "${join(",", formatlist("%s=http://%s:2380", aws_instance.etcd_node.*.id, aws_instance.etcd_node.*.public_ip))}"
    CLUSTER_STATE = "new"
    TOKEN = "${var.cluster_token}"
  }
}