
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "server_sg" {
  name        = "${var.project_name}-server-sg"
  description = "Security Group para los Servidores Web"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-server-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_servers" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

description = "Permitir trafico HTTP desde el balanceador"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out_servers" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_launch_template" "app_server" {
  name_prefix   = "${var.project_name}-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.server_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>SeaBook - Servidor: $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-node"
    }
  }
}

resource "aws_autoscaling_group" "seabook_asg" {
  name                = "${var.project_name}-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [aws_lb_target_group.seabook_tg.arn]

  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 600
  wait_for_capacity_timeout = "10m"
}
