resource "tls_private_key" "app-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "app-key-pair" {
  key_name   = "${var.app_name}-server-key"
  public_key = tls_private_key.app-key.public_key_openssh
}

resource "aws_instance" "app" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = var.app_instance_type
  subnet_id = local.private_subnet_id
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  key_name               = aws_key_pair.app-key-pair.key_name
  tags = {
    Name = "${var.app_name}-${var.app_version}"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo usermod -aG docker ubuntu
              sudo apt-get install -y git
              sudo systemctl enable docker
              sudo docker login --username=${var.dockerhub_username} --password=${var.dockerhub_password}
              sudo docker run -d -p 80:${var.container_port} -e WEATHER_API_KEY=${var.WEATHER_API_KEY} -e LOCATION_API_KEY=${var.LOCATION_API_KEY} ${var.app_docker_image}:${var.image_tag}
              EOF
}


resource "aws_lb_target_group" "target_group" {
  name     = "${var.app_name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.app.id
}

resource "aws_lb" "load_balancer" {
  name               = "${var.app_name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB-sg.id]
  subnets            = [var.public_subnet_a_id, var.public_subnet_b_id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.ssl_cert_arn


  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
