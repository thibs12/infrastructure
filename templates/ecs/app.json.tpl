[
  {
    "name": "app",
    "image": "${app_image}",
    "repositoryCredentials": {
      "credentialsParameter": "arn:aws:secretsmanager:eu-west-1:891377364444:secret:docker_credentials-XgV9MJ"
      },
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]