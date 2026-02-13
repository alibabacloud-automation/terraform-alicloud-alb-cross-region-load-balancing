# ALB Cross-Region Load Balancing Complete Example

This example demonstrates how to use the ALB Cross-Region Load Balancing module to create a complete cross-region load balancing solution using Alibaba Cloud services.

## Architecture Overview

This example creates:
- CEN (Cloud Enterprise Network) instance for cross-region connectivity
- Transit Routers in three regions (cn-chengdu, cn-shanghai, cn-qingdao)
- VPCs and VSwitches in each region
- ECS instances as backend servers
- ALB (Application Load Balancer) for load balancing
- Security groups and routing configurations

## Prerequisites

- Alibaba Cloud account with sufficient permissions
- Terraform >= 1.0 installed
- Alicloud provider >= 1.131.0

## Usage

1. Clone this repository and navigate to this example directory:
   ```bash
   cd examples/complete
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and modify variables as needed in `terraform.tfvars` or use default values.

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

6. After deployment, you can access the ALB DNS name from the outputs to test the load balancing functionality.

## Customization

You can customize the deployment by modifying variables in `variables.tf` or creating a `terraform.tfvars` file:

```hcl
# Example terraform.tfvars
region1 = "cn-beijing"
region2 = "cn-hangzhou" 
region3 = "cn-shenzhen"

cen_instance_name = "my-cross-region-cen"
alb_name = "my-alb"

# Customize VPC CIDR blocks
vpc1_cidr = "10.1.0.0/16"
vpc2_cidr = "10.2.0.0/16"
vpc3_cidr = "10.3.0.0/16"
```

## Important Notes

1. **Multi-Region Setup**: This example uses three regions. Ensure all specified regions are available in your Alibaba Cloud account.

2. **Costs**: This example creates multiple resources across regions, which may incur costs. Remember to destroy resources when no longer needed.

3. **Security**: The default security group rules allow all traffic. In production, configure more restrictive rules.

4. **ECS Passwords**: The example uses a default password. In production, use secure passwords and consider key-pair authentication.

## Clean Up

To destroy all created resources:

```bash
terraform destroy
```

## Outputs

The example provides several outputs including:
- CEN instance ID
- ALB DNS name and ID
- VPC IDs in all regions
- ECS private IP addresses
- Transit Router IDs

These outputs can be used to reference the created resources in other configurations or for monitoring purposes.