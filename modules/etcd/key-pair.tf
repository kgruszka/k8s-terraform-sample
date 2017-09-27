resource "aws_key_pair" "etcd-ec2-key" {
  key_name = "${var.app_tag}_etcd_cluster"
  public_key = "${var.public_key}"
}