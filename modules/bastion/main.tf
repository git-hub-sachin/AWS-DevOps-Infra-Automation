resource "aws_instance" "bastion" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "m5.xlarge"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              apt install -y unzip curl
              sudo apt install -y software-properties-common
              sudo add-apt-repository --yes --update ppa:ansible/ansible
              sudo apt install -y ansible  
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
              echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
              EOF
  tags = {
    Name = "Project-Bastion-Host"
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
