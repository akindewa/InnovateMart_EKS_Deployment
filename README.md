# InnovateMart - Deployment & Architecture Guide

##  Live Application Access
- **Application URL**: `http://[LOAD-BALANCER-URL]` (Deployed upon submission)  
- **Status**:  Production Ready  
- **Kubernetes Cluster**: `innovatemart-prod-eks`  
| Kubernetes Version | 1.32 |

---

##  Architecture Overview

### Infrastructure Components
- **AWS EKS Cluster**: Managed Kubernetes service in `eu-west-1` region  
- **Application Load Balancer**: External access via AWS ELB  
- **S3 Backend**: Terraform state management (`innovatemart` bucket)  
- **VPC & Networking**: Custom VPC with public/private subnets  
- **IAM Roles**: EKS cluster and node group service roles  

### Application Stack
- **Frontend**: React UI application  
- **Container**: Dockerized deployment  
- **Service**: Kubernetes LoadBalancer service (port 80)  
- **Namespace**: Default Kubernetes namespace  

### Deployment Architecture
```
  Internet → AWS Load Balancer → EKS Service → Kubernetes Pods → React UI

  ```  


### Key Resources
| Component   | Details                   |
|-------------|---------------------------|
| EKS Cluster | innovatemart-prod-eks     |
| Region      | eu-west-1 (Ireland)       |
| Service     | LoadBalancer (external)   |
| Infra Mgmt  | Terraform (IaC)           |

---

##  Folder Structure

```bash
project2/
│── .github/
│ └── workflows/
│ └── terraform.yml         # GitHub Actions pipeline for Terraform
│
│── doc/          # Documentation file (IAM access guide)
│ └── iam.md      # IAM user access documentation
│
│── infra/        # Terraform Infrastructure-as-Code
│ ├── backend.tf  # Terraform remote backend (S3 + DynamoDB lock)
│ ├── cluster-info.txt     # EKS cluster details (auto-generated)
│ ├── eks.tf     # EKS cluster + node group definitions
│ ├── iam.tf     # IAM roles & policies (EKS, nodes, etc.)
│ ├── main.tf    # Root Terraform configuration entrypoint
│ ├── outputs.tf  # Outputs (cluster name, VPC ID, etc.)
│ ├── provider.tf  # AWS provider config
│ ├── variables.tf # Input variables for reusability
│ └── vpc.tf # VPC, subnets, routing, NAT Gateway, IGW
│
│── k8s/   # Kubernetes manifests
│ ├── kubernetes.yaml    # Core Kubernetes objects (deployments, services, etc.)
│ └── rbac-readonly.yaml # RBAC config for read-only developer user
│
│── .gitignore   # Git ignore rules
│── README.md # Project overview & deployment guide

```



## Developer Access (Read-Only IAM User)

For detailed steps on configuring the IAM user and accessing the cluster, see the [IAM Access Guide](./doc/iam.md).



##  Deployment Commands (For Administrators)


##  Prerequisites
- Terraform >= 1.0  
- AWS CLI (configured with an IAM user with valid credentials)  
- kubectl  
- Git installed
- Docker (for local testing) 

## Quickstart
**Clone and setup**
```bash
   git clone <repository-url>
   cd project2
```

## Infrastructure Deployment
```bash
# From project root
# Navigate to infrastructure directory

cd infra/

# Initialize Terraform
terraform init

# Plan infrastructure changes
terraform plan

# Deploy infrastructure
terraform apply
```

## Application Deployment
```bash
# Navigate to Kubernetes manifests
cd k8s/

# Apply Kubernetes configurations
kubectl apply -f .

# Verify deployment
kubectl get service ui
```

## Accessing the Application URL

```bash
# Get LoadBalancer URL
kubectl get service ui -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Application will be accessible at:
# http://[LOAD-BALANCER-DNS]/
```

## CI/CD Pipeline

This project includes a GitHub Actions workflow (`.github/workflows/terraform.yml`) that automates infrastructure management:

- **Terraform Init & Validate** on pull requests  
- **Terraform Plan** for review before merge  
- **Terraform Apply** on push to `main` (with approval)  

This ensures:
- Consistent infrastructure deployment  
- Automatic validation of changes  
- Reduced risk of manual errors  


## Quick Verification

```bash
# Verify everything is working
kubectl get service ui
kubectl get pods
kubectl logs -l app=ui --tail=10
```


## Monitoring & Verification

```bash
# Cluster status
kubectl cluster-info

# Service status
kubectl get service ui -o wide

# Pod health
kubectl get pods -o wide

# Recent deployments/events
kubectl get events --sort-by='.lastTimestamp'
```

## Technical Specifications

| Component          | Details                            |
| ------------------ | ---------------------------------- |
| Kubernetes Version | Latest EKS supported version       |
| Container Runtime  | containerd                         |
| Service Type       | LoadBalancer (AWS ELB integration) |
| Networking         | AWS VPC CNI                        |
| Storage            | EBS-backed persistent volumes      |
| High Availability  | Multi-AZ deployment                |


## Cost Management
**Important**: This deployment incurs AWS charges:

- EKS Cluster: ~$72/month
- Load Balancer: ~$16/month
- EC2 Instances: ~$30/month (1 x t3.medium)
- NAT Gateways: ~$32/month
- Run `terraform destroy` when done testing

## Cleanup Instructions

To avoid unnecessary billing, destroy resources after testing:

```bash
# Delete Kubernetes resources
kubectl delete -f k8s/

# Destroy Terraform-managed infrastructure
cd infra/
terraform destroy
```















