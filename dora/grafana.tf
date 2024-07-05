resource "aws_security_group" "grafana_sg" {
  name        = "${var.sg_name}-grafana"
  description = "Security group for Grafana instance"
  vpc_id      = data.terraform_remote_state.app.outputs.vpc_id
  tags = var.tags

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "grafana" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"   

    vpc_security_group_ids = [aws_security_group.grafana_sg.id]
    subnet_id = data.terraform_remote_state.app.outputs.public_subnet_id_az1

    # User data script to install Docker and run Grafana
    user_data = <<-EOF
                    #!/bin/bash
                    sudo apt-get update
                    sudo apt-get install -y docker.io
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    sudo docker run -d -p 3000:3000 --name=grafana grafana/grafana
                    EOF

    tags = var.tags
}