output "alb_dns_name" {
  description = "URL Pública del Balanceador de Carga"
  value       = "http://${aws_lb.seabook_alb.dns_name}"
}

output "global_accelerator_ips" {
  description = "IPs Anycast del Acelerador Global"
  value       = aws_globalaccelerator_accelerator.seabook_ga.ip_sets
}

output "global_accelerator_dns" {
  description = "DNS del Acelerador"
  value       = "http://${aws_globalaccelerator_accelerator.seabook_ga.dns_name}"
}