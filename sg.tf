# ----------------------------
# SSH Security Group
# ----------------------------
resource "aws_security_group" "ssh" {
  name        = "${var.project_name}-ssh-sg"
  description = "Allow SSH only from my public IP"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-ssh-sg"
    Managed = "terraform"
  }
}

# ----------------------------
# Generate SSH Key Pair (local)
# ----------------------------
resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

# ----------------------------
# Upload Public Key to AWS
# ----------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name    = "${var.project_name}-key"
    Managed = "terraform"
  }
}

# ----------------------------
# Save Private Key Locally
# ----------------------------
resource "local_file" "private_key" {
  filename        = "${path.module}/${var.project_name}.pem"
  content         = tls_private_key.this.private_key_openssh
  file_permission = "0600"
}
