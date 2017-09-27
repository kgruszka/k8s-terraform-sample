resource "aws_elb" "kubernetes_manager" {
  name = "kubernetes-manager"
  security_groups = ["${var.manager_elb_security_group_id}"]
  subnets = ["${var.subnet_id}"]
  instances = ["${aws_instance.kubernetes_manager.*.id}"]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/healthz"
    interval            = 15
  }

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform"
    Role = "Kubernetes manager elb"
  }
}

resource "aws_elb" "kubernetes_worker" {
  name = "kubernetes-worker"
  security_groups = ["${var.worker_elb_security_group_id}"]
  subnets = ["${var.subnet_id}"]
  instances = ["${aws_instance.kubernetes_worker.*.id}"]

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 15
  }

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform"
    Role = "Kubernetes worker elb"
  }
}
