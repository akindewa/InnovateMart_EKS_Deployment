  # Documentation on how to deploy

  # InnovateMart – Project Bedrock Deployment

  ## 1. Project Introduction

InnovateMart is a fast-growing e-commerce startup, and “Project Bedrock” is the task to deploy the **Retail Store Sample Application** on a production-grade Kubernetes environment. 

This project provisions AWS infrastructure using Terraform.


## 2. Prerequisites
- Terraform >= 1.0  
- AWS CLI (configured with an IAM user with valid credentials)  
- kubectl  
- Git installed
- Docker (for local testing)  


## Features
- VPC setup (`vpc.tf`)
- IAM roles & policies (`iam.tf`)
- Security groups (`security.tf`)
- EKS cluster deployment (`eks.tf`)



## 3. Local App Check (Optional)
Before working on AWS, I cloned and ran the app locally:  
```bash
git clone https://github.com/aws-containers/retail-store-sample-app
cd retail-store-sample-app
docker-compose up
```


## 4. Infrastructure (Terraform)

### VPC

- 1 VPC, CIDR 10.0.0.0/16

- 3 public subnets (one in each AZ)

- map_public_ip_on_launch = true → without this, nodes won’t get IPs and the cluster fails.
### EKS
```bash
cluster_version = "1.32"   # 1.30 is deprecated
instance_types  = ["t2.micro"]   # free tier eligible
```
- IRSA enabled for service accounts.

- Public subnets used (avoids NAT Gateway bills).

- Node group: min=1, max=1, desired=1.



##  Project Structure
```
innovatemart-eks/
│── README.md               # Project documentation
│── vpc.tf                  # VPC, subnets, routing, IGW
│── eks.tf                  # EKS cluster + node group
│── iam.tf                  # IAM roles & policies for EKS + nodes
│── security.tf             # Security groups (optional)
│── variables.tf            # Input variables for reusability
│── outputs.tf              # Outputs (VPC ID, cluster name, etc.)
│── provider.tf             # AWS provider config
│── manifests/              # Kubernetes app manifests (YAML files)
│    ├── namespace.yaml
│    ├── deployment.yaml
│    ├── service.yaml
│    └── configmap.yaml
│── .github/
│    └── workflows/         # GitHub Actions pipeline for Terraform
│         └── terraform.yml

```

### Explanation of Files

- vpc.tf → defines the VPC, 2–3 public subnets, Internet Gateway, and routing.

- eks.tf → provisions the EKS control plane + node group (t2.micro).

- iam.tf → IAM roles for the EKS cluster and read-only dev user.

- security.tf → security groups (if needed for cluster networking).

- variables.tf → lets you parameterize CIDRs, instance types, cluster name, etc.

- outputs.tf → makes Terraform print out cluster name, VPC ID, and kubeconfig info.

- provider.tf → where you set provider "aws" { region = "eu-west-1" }.

- manifests/ → Kubernetes YAML files for deploying the retail-store app.

- .github/workflows/terraform.yml → CI/CD pipeline (plan/apply triggered by Git pushes).






## Commands
```
terraform init  // to initialize terraform
terraform plan -out=tfplan   //to review the changes
terraform apply tfplan  //to apply the infrastructure
```
#### Errors I hit:

- Subnet IPs not auto-assigned → fixed by enabling public IPs.

- Wrong cluster version (1.30) → bumped to 1.32.

## 5. Deploying to EKS
After Terraform created the cluster:
```
aws eks update-kubeconfig --name innovatemart-prod-eks --region us-east-1
kubectl get nodes
```

- If nodes show up → cluster is alive.

- Deployed app (after manifests are ready):

```
kubectl apply -f manifests/
kubectl get pods -A
```

## 6. IAM for Devs

I added a read-only IAM user so devs can:

- Run aws eks update-kubeconfig ...

- View cluster state via kubectl.

- Can’t break production.

## 9. Lessons Learned

Always check Kubernetes version support.

Public subnets saved me from NAT costs.

Even failed resources cost money.

Terraform errors taught me to read logs carefully.