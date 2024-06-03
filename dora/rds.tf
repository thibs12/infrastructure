resource "aws_security_group" "rds_sg" {
  name        = "${var.sg_name}-rds"
  description = "Security group for RDS instance"
  vpc_id      = data.terraform_remote_state.app.outputs.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
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


resource "aws_db_instance" "rds_instance" {
  engine                 = "mysql"
  identifier             = "dora-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
}
