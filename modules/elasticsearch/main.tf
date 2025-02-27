resource "aws_instance" "elasticsearch" {
  count         = 3
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t3.medium"
  subnet_id     = element(var.private_subnet_ids, count.index % 2)
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.elasticsearch_sg.id]
  tags = {
    Name = "Project-ElasticSearch-${count.index}"
  }
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
    delete_on_termination = true
  }
}

resource "aws_security_group" "elasticsearch_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  # ingress {
  #   from_port   = 9200
  #   to_port     = 9300
  #   protocol    = "tcp"
  #   cidr_blocks = [var.vpc_cidr]
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Project-elasticsearch-sg"
  }
}