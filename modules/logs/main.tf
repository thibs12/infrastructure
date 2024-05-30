resource "aws_cloudwatch_log_group" "log_group" {
    name              = var.log_group_name
    retention_in_days = 30

    tags = {
        Name = "todolist_log_group"
    }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
    name           = "todolist_log_stream"
    log_group_name = aws_cloudwatch_log_group.log_group.name
}