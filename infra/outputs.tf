output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Elastic IP address"
  value       = aws_eip.main.public_ip
}

output "domain_name" {
  description = "Domain name"
  value       = var.domain_name
}

output "ssh_user" {
  description = "SSH username for the instance"
  value       = "admin"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh admin@${aws_eip.main.public_ip}"
}
