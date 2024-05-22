# ALB Security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.sg_name}-alb"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   # Allow traffic on port 3306 for mysql db between containers
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self = true # Allow traffic from the same security group
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to ECS Cluster should only come from ALB
resource "aws_security_group" "ecs_sg" {
  name        = "${var.sg_name}-ecs"
  description = "Allow traffic from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow traffic on port 3306 for mysql db between containers
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self = true # Allow traffic from the same security group
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
