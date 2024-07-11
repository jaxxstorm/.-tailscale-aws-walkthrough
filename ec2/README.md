# EC2 Instance

This example shows a representation of how you'd connect to an EC2 instance directly, by installing Tailscale directly on the host.

It also enables the SSH feature of Tailscale so you can connect directly to the instance via SSH

## Components

1. Ubuntu Tailscale Module
2. AWS AMI Data Source
3. Security Group
4. EC2 Instance
5. VPC Configuration

## Prerequisites

- Terraform installed
- AWS CLI configured with appropriate credentials
- Tailscale account and auth key

## Usage

1. Clone this repository
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Set your Tailscale auth key:
   ```
   export TF_VAR_tailscale_auth_key="your-auth-key-here"
   ```
4. Review and adjust variables as needed
5. Plan your deployment:
   ```
   terraform plan
   ```
6. Apply the configuration:
   ```
   terraform apply
   ```

## Configuration Details

### Ubuntu Tailscale Module

This module sets up Tailscale on the EC2 instance:
- Hostname: "aws-lnl-host"
- SSH enabled
- Advertised tags: ["tag:client"]

### AWS AMI

Uses the latest Ubuntu 22.04 LTS AMI.

### Security Group

Allows all outbound traffic. Inbound rules should be configured as needed.

### EC2 Instance

- Instance type: t3.micro
- Placed in a private subnet
- Uses SSM for management
- Tailscale configured via user data

### VPC Configuration

- CIDR: 10.1.0.0/16
- 3 public and 3 private subnets
- NAT gateway enabled

## Notes

- Ensure your AWS credentials have the necessary permissions.
- Review and adjust the security group rules as per your requirements.
- The EC2 instance is configured to use AWS Systems Manager (SSM) for management.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.