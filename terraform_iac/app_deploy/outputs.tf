output "details" {
  value = {
    aws_region = local.aws_region
    private_ip = aws_instance.app.private_ip
    vpc_id = local.vpc_id
    public_subnet_a_id = local.public_subnet_a_id
    public_subnet_b_id = local.public_subnet_b_id
    private_subnet_id = local.private_subnet_id
    }
}

output "private_key" {
  value       = tls_private_key.app-key.private_key_pem
  sensitive   = true
  description = "App private key."
}
