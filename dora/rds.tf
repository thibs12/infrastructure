resource "aws_security_group" "rds_sg" {
  name        = "${var.sg_name}-rds"
  description = "Security group for RDS instance"
  vpc_id      = data.terraform_remote_state.app.outputs.vpc_id
  tags        = var.tags

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

  tags = var.tags
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "sg for the db bastion"
  vpc_id      = data.terraform_remote_state.app.outputs.vpc_id
  tags        = merge(var.tags, {
    "Name" = "TL-bastion-sg"
  })

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

resource "aws_instance" "bastion" {
  ami                    = var.ami_bastion
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = data.terraform_remote_state.app.outputs.public_subnet_id_az1

  tags = merge(var.tags, {
    "Name" = "bastion"
  })
}
