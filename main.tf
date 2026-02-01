resource "aws_instance" "this" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t3.micro"

  tags = {
    Name    = var.project_name
    Managed = "terraform"
  }
}
