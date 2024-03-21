resource "aws_network_acl" "private-NACL" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-PVT-NACL"
  }
}

resource "aws_network_acl_rule" "pvt-in-intrnl" {
  network_acl_id = aws_network_acl.private-NACL.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "10.0.0.0/16"
}

resource "aws_network_acl_rule" "pvt-in-ephmrl" {
  network_acl_id = aws_network_acl.private-NACL.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pvt-out-intrnt" {
  network_acl_id = aws_network_acl.private-NACL.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "10.0.0.0/16"
}

resource "aws_network_acl_rule" "pvt-out-443" {
  network_acl_id = aws_network_acl.private-NACL.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "private_association" {
  network_acl_id = aws_network_acl.private-NACL.id
  subnet_id      = aws_subnet.private.id
}



resource "aws_network_acl" "public-NACL" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-PUB-NACL"
  }
}

resource "aws_network_acl_rule" "pub-in-443" {
  network_acl_id = aws_network_acl.public-NACL.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub-in-80" {
  network_acl_id = aws_network_acl.public-NACL.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 80
  to_port        = 80
  cidr_block     = "10.0.0.0/16"
}

resource "aws_network_acl_rule" "pub-in-22" {
  network_acl_id = aws_network_acl.public-NACL.id
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 22
  to_port        = 22
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub-in-ephmrl" {
  network_acl_id = aws_network_acl.public-NACL.id
  rule_number    = 400
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub-out-intrnt" {
  network_acl_id = aws_network_acl.public-NACL.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "public-a_association" {
  network_acl_id = aws_network_acl.public-NACL.id
  subnet_id      = aws_subnet.public-a.id
}

resource "aws_network_acl_association" "public-b_association" {
  network_acl_id = aws_network_acl.public-NACL.id
  subnet_id      = aws_subnet.public-b.id
}