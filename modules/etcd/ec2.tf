resource "aws_instance" "etcd_node" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  count = "${var.node_count}"
  key_name = "${aws_key_pair.etcd-ec2-key.key_name}"
  associate_public_ip_address = true
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.security_group_id}"]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes etcd"
  }
}

resource "null_resource" "etcd_provisioning" {
  depends_on = ["aws_instance.etcd_node"]
  count = "${aws_instance.etcd_node.count}"

  triggers {
    etcd_instance_ids = "${join(",", aws_instance.etcd_node.*.id)}"
  }

  connection {
    bastion_host = "${var.bastion_public_ip}"
    host = "${element(aws_instance.etcd_node.*.private_ip, count.index)}"
    user = "${var.ec2_user}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    content = "${element(data.template_file.init.*.rendered, count.index)}"
    destination = "/home/ec2-user/etcd-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y && sudo yum install -y nohup",
      "sudo nohup sh /home/ec2-user/etcd-init.sh > /tmp/etcd.log &"
    ]
  }
}

output "etcd_cluster_ips" {
  value = "${aws_instance.etcd_node.*.private_ip}"
}