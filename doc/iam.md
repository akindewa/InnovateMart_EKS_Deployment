# InnovateMart EKS Developer Access Setup

## Table of Contents
- [Overview](#overview)
- [User Account Details](#user-account-details)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Step 1: Obtain Access Credentials](#step-1-obtain-access-credentials)
  - [Step 2: Configure AWS CLI](#step-2-configure-aws-cli)
  - [Step 3: Configure kubectl](#step-3-configure-kubectl)
- [Usage](#usage)
  - [📊 Monitoring and Debugging Commands](#-monitoring-and-debugging-commands)
  - [❌ Restricted Operations](#-restricted-operations)
  - [💡 Common Use Cases](#-common-use-cases)
  - [🔧 Useful Aliases](#-useful-aliases)
- [Troubleshooting](#troubleshooting)
- [Debug Commands](#debug-commands)
- [Contributing](#contributing)
- [Support](#support)
- [Cluster Information](#cluster-information)
- [License](#license)

---

## Overview
This README provides setup instructions for development team members to access the InnovateMart EKS cluster with read-only permissions.  

The setup enables developers to:
- View application logs
- Describe pod configurations
- Check service status
- Monitor cluster resources  

**This setup combines AWS IAM read-only policies with a Kubernetes RBAC ClusterRoleBinding. Both are required: IAM policies allow AWS authentication, and RBAC enforces read-only behavior inside the cluster.**

**Important:** This user has read-only access and cannot modify any cluster resources.

---

## User Account Details
| Field       | Value                               |
|-------------|-------------------------------------|
| IAM Username | eks-developer-readonly              |
| Access Type  | Read-only                          |
| Scope        | EKS cluster resources and AWS console |
| Created By   | Infrastructure team via Terraform  |

---

## Prerequisites
Before beginning setup, ensure you have:
- **AWS CLI v2.0+ installed** ([Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))  
- **kubectl v1.21+ installed** ([Installation Guide](https://kubernetes.io/docs/tasks/tools/))  
- **Access credentials provided by infrastructure team**  

---

## Quick Start
1. Get credentials from infrastructure team  
2. Configure AWS profile:

```bash
   aws configure --profile developer
```
3. Setup kubectl access:
```
aws eks update-kubeconfig --region eu-west-1 --name innovatemart-prod-eks --profile developer
```

4. Test access:
```
kubectl get pods --all-namespaces
```

## Installation
### Step 1: Obtain Access Credentials

Credentials are securely shared by the infrastructure team (via AWS IAM access key).

It contains:
- Access Key ID (20 characters)
- Secret Access Key (40 characters)


### Step 2: Configure AWS CLI
Create a dedicated profile for development access:
```
   aws configure --profile developer
```
Enter when prompted:

- AWS Access Key ID: [From Step 1]

- AWS Secret Access Key: [From Step 1]

- Default region: eu-west-1

- Output format: json

**Verify configuration**:
```
aws sts get-caller-identity --profile developer
```
**Expected Response**
```
{
    "UserId": "AIDA...",
    "Account": "919113286163",
    "Arn": "arn:aws:iam::919113286163:user/eks-developer-readonly"
}
```

### Step 3: Configure kubectl
**Update kubeconfig for cluster access:**
```
aws eks update-kubeconfig --region eu-west-1 --name innovatemart-prod-eks --profile developer
```
**Verify cluster connectivity:**
```
kubectl cluster-info
```


### Step 4: Apply Kubernetes RBAC Binding

The IAM user must also be mapped to a Kubernetes read-only role.
**Apply the manifest (already included in the repo as rbac-readonly.yaml):**
```
kubectl apply -f rbac-readonly.yaml
```

The RBAC binding ensures that the IAM user can:

- View pods and logs

- Check services

- Monitor resources

But cannot create, modify, or delete any resources.


### Usage
### Monitoring and Debugging Commands

**View Pod Status**
```
# List all pods with status
kubectl get pods --all-namespaces

# Get detailed pod information
kubectl describe pod <pod-name> -n <namespace>

# Check resource usage (if metrics available)
kubectl top pods --all-namespaces
```

**Access Application Logs**
```
# View current logs
kubectl logs <pod-name> -n <namespace>

# Follow logs in real-time
kubectl logs -f <pod-name> -n <namespace>

# View previous container logs
kubectl logs <pod-name> -n <namespace> --previous

# Multiple containers in pod
kubectl logs <pod-name> -c <container-name> -n <namespace>
```

**Check Services and Networking**
```
# List all services
kubectl get services --all-namespaces

# Describe service details
kubectl describe service <service-name> -n <namespace>

# Check service endpoints
kubectl get endpoints --all-namespaces
```

**Node and Cluster Information**
```
# View cluster nodes
kubectl get nodes -o wide

# Detailed node information
kubectl describe nodes

# Cluster information
kubectl cluster-info
```

### Restricted Operations
**These commands will fail with "forbidden" errors (confirming read-only access):**
```
kubectl create namespace test
kubectl apply -f manifest.yaml
kubectl delete pod <pod-name>
kubectl scale deployment <name> --replicas=3
kubectl edit deployment <name>
```
### Common Use Cases

**Identify failing pods:**
```
kubectl get pods --all-namespaces | grep -v Running
```
**Investigate specific issues:**
```
kubectl describe pod <failing-pod> -n <namespace>
kubectl logs <failing-pod> -n <namespace> --tail=50
```
**Check recent events:**
```
kubectl get events --all-namespaces --sort-by='.lastTimestamp' | tail -20
```
**Check all services:**
```
kubectl get services --all-namespaces -o wide
```
**Verify deployments:**
```
kubectl get deployments --all-namespaces
kubectl describe deployment <app-name> -n <namespace>
```
### Troubleshooting

**Common Issues and Solutions**

| Issue                                        | Solution                                                                                                                                                                         |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "error: You must be logged in to the server" | Verify AWS profile: `aws sts get-caller-identity --profile developer`<br>Re-run: `aws eks update-kubeconfig --region eu-west-1 --name innovatemart-prod-eks --profile developer` |
| "Unable to connect to the server"            | Check cluster status in AWS Console<br>Verify network connectivity<br>Confirm cluster is running                                                                                 |
| "forbidden: User cannot..."                  | Confirm correct context: `kubectl config current-context`<br>Verify with infrastructure team<br>Check cluster access entries                                                     |
| "command not found"                          | Install AWS CLI: `aws --version`<br>Install kubectl: `kubectl version --client`<br>Check PATH configuration                                                                      |


### Debug Commands

```
# Check current context
kubectl config current-context

# List available contexts
kubectl config get-contexts

# Verify AWS credentials
aws sts get-caller-identity --profile developer

# Test basic connectivity
kubectl get nodes
```
### Cluster Information

| Property           | Value                 |
| ------------------ | --------------------- |
| Cluster Name       | innovatemart-prod-eks |
| Region             | eu-west-1             |
| Kubernetes Version | 1.32                  |
| Environment        | dev                   |


