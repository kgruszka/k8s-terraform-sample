resource "aws_subnet" "kubernetes" {
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.kubernetes.id}"
  availability_zone = "${var.availability_zone}"

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes"
  }
}

resource "aws_internet_gateway" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags = {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform"
    Role = "Kubernetes"
  }
}

resource "aws_route_table" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags = {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform"
    Role = "Kubernetes"
  }
}

resource "aws_route" "kubernetes_egress_route" {
  route_table_id = "${aws_route_table.kubernetes.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.kubernetes.id}"
}

resource "aws_route_table_association" "kubernetes" {
  route_table_id = "${aws_route_table.kubernetes.id}"
  subnet_id = "${aws_subnet.kubernetes.id}"
}

output "kubernetes_subnet_id" {
  value = "${aws_subnet.kubernetes.id}"
}

output "kubernetes_subnet_cidr" {
  value = "${aws_subnet.kubernetes.cidr_block}"
}

output "kubernetes_pod_cidr" {
  value = "10.200.0.0/24"
}

output "kubernetes_route_table_id" {
  value = "${aws_route_table.kubernetes.id}"
}