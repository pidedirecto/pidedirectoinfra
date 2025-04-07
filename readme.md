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

   By default, this will show the plan for all resources in the environment.

4. **Apply the infrastructure changes**
   ```sh
   terraform apply
   ```

   ⚠️ Note: This will attempt to create/update all resources in the environment.

   For now, we are applying changes module by module using the --target flag.
   Example:
   ```sh
   terraform apply --target=module.pidedirectofileserver
   ```

5. **Destroy the infrastructure (if needed)**
   ```sh
   terraform destroy
   ```
   
   ⚠️ Note: This will destroy all resources in the environment.

   If you want to destroy a specific module only, use the --target flag:
   Example:
   ```sh
   terraform destroy --target=module.pidedirectofileserver
   ```

## Notes
- Always review the plan output before applying changes.
- Use --target for incremental builds and selective destruction until the full infrastructure is stable.

