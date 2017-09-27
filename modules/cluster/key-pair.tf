resource "aws_key_pair" "kubernetes" {
  key_name = "${var.app_tag}_kubernetes_cluster"
  public_key = "${var.cluster_public_key}"
}