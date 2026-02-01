# ----------------------------
# Get latest Amazon Linux 2023 AMI
# ----------------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "this" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name    = "${var.project_name}-ec2"
    Managed = "terraform"
  }

}
