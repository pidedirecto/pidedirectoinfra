# Terraform Infrastructure Setup

## Prerequisites

Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI (configured with appropriate credentials)

## Setup Instructions

1. **Initialize Terraform**
   ```sh
   cd environments
   cd {dev|prod|otherStage}
   terraform init
   ```

2. **Create a `terraform.tfvars` file**
   Copy the variables from `variables.tf` and set the values in `terraform.tfvars`.
   
   Example:
   ```hcl
   region = "us-east-1"
   environment = "dev"
   ```

3. **Plan the infrastructure**
   ```sh
   terraform plan
   ```

4. **Apply the infrastructure changes**
   ```sh
   terraform apply
   ```

5. **Destroy the infrastructure (if needed)**
   ```sh
   terraform destroy
   ```

## Notes
- Always review the plan output before applying changes.

