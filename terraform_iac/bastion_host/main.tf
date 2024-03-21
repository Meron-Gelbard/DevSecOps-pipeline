
resource "tls_private_key" "bastion-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion-key-pair" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion-key.public_key_openssh
}

resource "null_resource" "save_private_key" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.bastion-key.private_key_pem}' > bastion-key.pem && chmod 400 bastion-key.pem"
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "${var.app_name}-bastion-sg"
  description = "Bastion host external SSH"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.app_name}-bastion-sg"
  }
}


resource "aws_instance" "bastion" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = local.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name               = aws_key_pair.bastion-key-pair.key_name
  tags = {
    Name = "${var.app_name}-bastion-host"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo '${var.app_private_key}' > /home/ubuntu/${var.app_name}-server-key.pem && chmod 400 /home/ubuntu/${var.app_name}-server-key.pem"
  #   ]

  #   connection {
  #     type     = "ssh"
  #     user     = "ubuntu"
  #     private_key = tls_private_key.bastion-key.private_key_pem
  #     host = self.public_ip
  #   }
  # }
}


