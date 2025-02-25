resource "aws_instance" "bastion" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "m5.xlarge"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  tags = {
    Name = "Project-Bastion-Host"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Project-Bastion-sg"
  }
}
