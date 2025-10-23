output "builder_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.builder.public_ip
}

output "ssh_private_key_path" {
  description = "Path to the generated private SSH key"
  value       = local_file.private_key.filename
  sensitive   = true
}

output "ssh_key_name" {
  description = "Name of the AWS SSH key pair"
  value       = aws_key_pair.builder_key.key_name
}

output "security_group_id" {
  description = "Security Group ID for the builder instance"
  value       = aws_security_group.builder_sg.id
}
