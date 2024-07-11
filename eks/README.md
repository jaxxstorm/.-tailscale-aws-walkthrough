# EKS Tailscale Demo Project

This Terraform project sets up an Amazon EKS (Elastic Kubernetes Service) cluster with Tailscale integration and deploys a demo application. The project demonstrates how to use Terraform to manage cloud infrastructure and Kubernetes resources.

## Project Components

1. EKS Cluster
2. Tailscale Operator
3. Demo Streamer Application

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed (version 1.0.0 or newer)
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed
- A Tailscale account with OAuth credentials

## Configuration

The project uses the following main configuration files:

- `main.tf`: Contains the EKS cluster configuration
- `providers.tf`: Configures the required providers (AWS, Kubernetes, Helm)
- `variables.tf`: Defines input variables (ensure you set the Tailscale OAuth credentials)

## Usage

1. Clone this repository:
   ```
   git clone <repository-url>
   cd eks-tailscale-demo
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Review the planned changes:
   ```
   terraform plan
   ```

4. Apply the Terraform configuration:
   ```
   terraform apply
   ```

5. After successful application, configure `kubectl` to interact with your new EKS cluster:
   ```
   aws eks update-kubeconfig --name <your cluster name> --region <your-aws-region>
   ```

## Project Structure

- EKS Cluster: A managed Kubernetes cluster on AWS
- Tailscale Operator: Deployed in the `tailscale` namespace
- Demo Streamer: A sample application deployed in the `demo` namespace
- Ingress: Configured to expose the Demo Streamer application via Tailscale

## Customization

You can customize the project by modifying the following:

- EKS cluster configuration in `main.tf`
- Tailscale Operator settings in the `helm_release` resource
- Demo application specifications in the `kubernetes_deployment` and related resources

## Cleanup

To destroy the created resources:

```
terraform destroy
```