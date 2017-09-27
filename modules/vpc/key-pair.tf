resource "aws_key_pair" "kubernetes" {
  public_key = "${var.bastion_public_key}"
  key_name = "${var.app_tag}_bastion_key"
}