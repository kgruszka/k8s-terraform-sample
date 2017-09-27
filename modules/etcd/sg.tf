//resource "aws_security_group" "etcd_node" {
//  name        = "etcd_nodes"
//  description = "Allow all inbound traffic"
//
//  ingress {
//    from_port   = 22
//    to_port     = 22
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  ingress {
//    from_port   = 0
//    to_port     = 2379
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  ingress {
//    from_port   = 0
//    to_port     = 2380
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  ingress {
//    from_port   = 0
//    to_port     = 2379
//    protocol    = "udp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  ingress {
//    from_port   = 0
//    to_port     = 2380
//    protocol    = "udp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  egress {
//    from_port       = 0
//    to_port         = 0
//    protocol        = "-1"
//    cidr_blocks     = ["0.0.0.0/0"]
//  }
//
//  tags {
//    Application = "dazndev"
//    ManagedBy = "Terraform",
//    Role = "Kubernetes etcd"
//  }
//}