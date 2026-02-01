output "output_name" {
  description = "Public IP for EC2 instance."
  value       = aws_instance.this.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance."
  value       = "ssh -i ${var.project_name}.pem ec2-user@${aws_instance.this.public_ip}"
}
