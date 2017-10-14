resource "aws_instance" "bastion" {
  ami = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  key_name = "${aws_key_pair.kubernetes.key_name}"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.kubernetes.id}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes_bastion.id}"]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes bastion"
  }
}

resource "null_resource" "bastion" {
  connection {
    host = "${aws_instance.bastion.public_ip}"
    user = "${var.bastion_user}"
    private_key = "${file(var.bastion_private_key_path)}"
  }

  provisioner "file" {
    source = "${var.bastion_private_key_path}"
    destination = "/home/${var.bastion_user}/.ssh/docker-cluster"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 .ssh/docker-cluster",
      "wget -q --show-progress --https-only --timestamping https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64",
      "chmod +x cfssl_linux-amd64 cfssljson_linux-amd64",
      "sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl",
      "sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson",
      "wget https://storage.googleapis.com/kubernetes-release/release/v1.7.4/bin/darwin/amd64/kubectl",
      "chmod +x kubectl",
      "sudo mv kubectl /usr/local/bin/"
    ]
  }
}

output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}