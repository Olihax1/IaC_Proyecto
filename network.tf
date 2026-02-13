# Global Accelerator
resource "aws_globalaccelerator_accelerator" "seabook_ga" {
  name            = "${var.project_name}-accelerator"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "ga_listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.seabook_ga.id
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "ga_endpoint" {
  listener_arn = aws_globalaccelerator_listener.ga_listener.id

  endpoint_configuration {
    endpoint_id = aws_lb.seabook_alb.arn
    weight      = 100
  }
}