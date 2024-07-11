# Security group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "rds-"
  description = "Allow inbound traffic to RDS"
  vpc_id      = module.vpc.vpc_id

  # Inbound rule: Allow MySQL traffic from within the VPC
  ingress {
    description = "Allow inbound from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  # Outbound rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# RDS instance configuration
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = "aws-lnl-rds"

  # Database engine configuration
  engine               = "mysql"
  engine_version       = "5.7"
  major_engine_version = "5.7"
  instance_class       = "db.t3.micro"
  allocated_storage    = 5

  # Database details
  db_name  = "example"
  username = "user"
  port     = "3306"

  # Security group association
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Subnet configuration
  create_db_subnet_group = true
  skip_final_snapshot    = true
  subnet_ids             = module.vpc.private_subnets

  # Parameter group
  family = "mysql5.7"

  # Disable deletion protection for easier management in non-production environments
  deletion_protection = false
}