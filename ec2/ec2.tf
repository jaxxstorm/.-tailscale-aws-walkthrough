module "ubuntu-tailscale" {
  source         = "git@github.com:lbrlabs/terraform-cloudinit-tailscale.git"
  auth_key       = var.tailscale_auth_key
  hostname       = "aws-lnl-host"
  enable_ssh = true
  advertise_tags = ["tag:client"]
}


data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "main" {
    name        = "aws-lnl-sg"
    description = "Allow all inbound traffic"
    vpc_id      = module.vpc.vpc_id
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "instance" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnets[0]

  ebs_optimized = true
  vpc_security_group_ids = [ aws_security_group.main.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  user_data_base64            = module.ubuntu-tailscale.rendered
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "aws-lnl-host"
  }
}
