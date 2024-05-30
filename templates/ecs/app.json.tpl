[
  {
    "name": "app",
    "image": "${app_image}",
    "repositoryCredentials": {
      "credentialsParameter": "arn:aws:secretsmanager:eu-west-1:891377364444:secret:docker_credentials-XgV9MJ"
      },
    "cpu": ${app_cpu},
    "memory": ${app_memory},
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
    ],
    "environment" : [
      {
        "name"  : "DBHOST",
        "value" : "mysql.database.com"
      },
      {
        "name": "DBPORT",
        "value": "3306"
      },
      {
        "name" : "ASPNETCORE_ENVIRONMENT",
        "value": "Production"
      }
    ],
    "healthCheck": {
      "command": ["CMD-SHELL", "curl -f localhost:${app_port}/api/todoitems || exit 1"],
      "interval": 15,
      "timeout": 5,
      "retries": 3,
      "startPeriod": 30
    }
  }
]