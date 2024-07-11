# AWS Tailscale Subnet Router with RDS

This Terraform project sets up an AWS environment with a Tailscale subnet router, a VPC, and an RDS instance. It's designed to create a secure and scalable infrastructure for running applications that require database access.

You can access the RDS database via the Tailscale subnet router.

## Components

1. **Tailscale Subnet Router**: Allows secure access to the AWS VPC through Tailscale.
2. **VPC**: A custom VPC with public and private subnets across multiple Availability Zones.
3. **EC2 Instance**: Runs the Tailscale subnet router.
4. **RDS Instance**: A MySQL database for application use.

## Prerequisites

- Terraform installed (version 1.0.0 or later)
- AWS CLI configured with appropriate credentials
- A Tailscale account and auth key

## Usage

1. Clone this repository:
   ```
   git clone [repository-url]
   cd [repository-name]
   ```

2. Create a `terraform.tfvars` file with the following content:
   ```hcl
   tailscale_auth_key = "your-tailscale-auth-key"
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Review the planned changes:
   ```
   terraform plan
   ```

5. Apply the configuration:
   ```
   terraform apply
   ```

## Configuration Details

### VPC
- CIDR: 172.16.0.0/16
- 3 public subnets and 3 private subnets
- NAT Gateway enabled

### EC2 Instance
- Ubuntu 22.04 LTS
- t3.micro instance type
- Located in a private subnet

### RDS Instance
- MySQL 5.7
- db.t3.micro instance class
- Located in private subnets
- Accessible only from within the VPC

## Security Considerations

- The EC2 instance is not directly accessible from the internet. Access is managed through Tailscale.
- The RDS instance is in a private subnet and only accessible from within the VPC.
- All resources use security groups to control inbound and outbound traffic.

## Customization

You can customize this configuration by modifying the following files:
- `main.tf`: Main Terraform configuration
- `variables.tf`: Define or modify input variables
- `outputs.tf`: Define outputs for important resource information

## Cleanup

To destroy the created resources:
```
terraform destroy
```

**Note**: This will permanently delete all resources created by this Terraform configuration. Use with caution.
