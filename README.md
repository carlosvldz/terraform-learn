# Terraform

Practice repository with Terraform.

## Run any project with:
```bash
# Download provider plugins
terraform init
# Validate syntax
terraform validate
# Plan
terraform plan
# Run
terraform apply
# Run (without approve)
terraform apply -auto-approve
# Destroy provisioned infrastructure
terraform destroy
```

---

+ [Basic Server with EC2 Instance](./basic-server-with-ec2/)

+ [Basic Server with EC2 Instance and Application Load Balancer](./ec2-with-loadbalancer/)

+ [Basic Server with EC2 Instance and Application Load Balancer (using variables, maps and validations)](./infra-reutilizable/)

+ [Loops with count & for_each](./loops-count%26foreach/)

+ [For expressions](./for-expressions/)

+ [Splat expressions](./splat-expressions/)

+ [Basic Server with EC2 Instance and Application Load Balancer](./infra-reutilizable-refactor/) (Refactoring using for expressions, loops to create resources and local variables)