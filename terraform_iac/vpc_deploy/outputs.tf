output "details" {
  value = {
    aws_region = var.aws_region
    vpc_id = aws_vpc.app_vpc.id,
    public_subnet_a_id = aws_subnet.public-a.id,
    public_subnet_b_id = aws_subnet.public-b.id,
    private_subnet_id = aws_subnet.private.id
  }
}
