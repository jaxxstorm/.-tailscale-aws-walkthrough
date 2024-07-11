output "aws_instance_id" {
    value = aws_instance.instance.id
}

output "rds_endpoint" {
    value = module.db.this_db_instance_endpoint
}