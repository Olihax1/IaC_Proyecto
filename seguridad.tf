resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Control de trafico para el ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

    description = "Permitir HTTP desde Internet"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_wafv2_web_acl" "seabook_waf" {
  name        = "${var.project_name}-waf"
  description = "WAF basico para monitoreo"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "SeabookWAFMetric"
    sampled_requests_enabled   = true
  }
  tags = {
    Name = "${var.project_name}-waf"
  }
#checkov:skip=CKV_AWS_192: "WAF basico sin inspeccion profunda para demo"
  #checkov:skip=CKV_AWS_175: "ACL sin reglas especificas para monitoreo inicial"
  #checkov:skip=CKV2_AWS_31: "Logging de WAF desactivado por costos"
}
