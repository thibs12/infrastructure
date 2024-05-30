[
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
      "interval": 30,
      "timeout": 5,
      "retries": 3,
      "startPeriod": 30
    }
  }
]