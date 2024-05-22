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
        "value" : "localhost"
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
    "dependsOn": [
      {
        "containerName": "mysql",
        "condition": "HEALTHY"
      }
    ]
  },
  {
    "name"      : "mysql",
    "image"     : "mysql:latest",
    "cpu": ${db_cpu},
    "memory": ${db_memory},
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 3306,
        "hostPort"      : 3306
      }
    ],
    "environment" : [
      {
        "name"  : "MYSQL_ROOT_PASSWORD",
        "value" : "rootpwd"
      },
      {
        "name"  : "MYSQL_DATABASE",
        "value" : "todolist"
      },
      {
        "name"  : "MYSQL_USER",
        "value" : "thibs"
      },
      {
        "name"  : "MYSQL_PASSWORD",
        "value" : "password"
      }
    ],
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group"         : "/ecs/mysql",
        "awslogs-region"        : "${aws_region}",
        "awslogs-stream-prefix" : "ecs"
      }
    },
    "healthCheck": {
      "command": ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 -P 3306"],
      "interval": 10,
      "timeout": 5,
      "retries": 3,
      "startPeriod": 30
    }
  }
]