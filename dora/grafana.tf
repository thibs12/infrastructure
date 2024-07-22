resource "aws_security_group" "grafana_sg" {
  name        = "${var.sg_name}-grafana"
  description = "Security group for Grafana instance"
  vpc_id      = data.terraform_remote_state.app.outputs.vpc_id
  tags        = var.tags

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

resource "aws_instance" "grafana" {
  ami           = var.ami_grafana
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  subnet_id              = data.terraform_remote_state.app.outputs.public_subnet_id_az1

  # User data script to install Docker and run Grafana
  user_data = <<-EOF
                    #!/bin/bash
                    sudo apt-get update
                    sudo apt-get install -y docker.io
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    sudo docker run -d -p 3000:3000 --name=grafana grafana/grafana
                    EOF

  tags = merge(var.tags, {
    "Name" = "grafana"
  })
}

# Grafana MYSQL data source
resource "grafana_data_source" "mysql" {
  uid           = "id_mysql_datasource"
  name          = "MySQL"
  type          = "mysql"
  url           = "${var.db_endpoint}:3306"
  database_name = var.db_name
  username      = var.db_username
  secure_json_data_encoded = jsonencode({
    password = "${var.db_password}"
  })
  is_default = true

  depends_on = [aws_db_instance.rds_instance, aws_instance.grafana]
}

# Grafana dashboard
data "template_file" "template_grafana_dashboard" {
  template = file("./dashboard_grafana.json")

  vars = {
    data_source_id = grafana_data_source.mysql.uid
  }
}

resource "grafana_dashboard" "dora_metrics" {
  config_json = data.template_file.template_grafana_dashboard.rendered
  depends_on  = [ grafana_data_source.mysql, aws_instance.grafana]
}
