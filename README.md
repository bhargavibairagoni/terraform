# Britannia Contractor Wage & Statutory Compliance Validation System
## Cloud Infrastructure as Code (Terraform) for DEV, UAT & PROD

### 1. Project Background & Context
Britannia operates with 18 factories where external contractors supply workforce labor. 
- Contractors disburse worker salaries, not Britannia directly.
- **Britannia's Objective**: Ensure zero discrepancies in worker payouts by cross-validating contractor muster rolls and payslips against actual biometric/attendance logs (**Matra**) and worker master data (**HRMS**).
- **Compliance Rules**: Verify statutory rules including Minimum Wages, State Overtime rules, Provident Fund (PF: 12% subject to statutory ceilings), Employee State Insurance (ESI: 0.75% worker, 3.25% employer), Professional Tax (PT), and Labour Welfare Fund (LWF).
- **Scale**: Pilot deployment for **1 factory** (~500–2,500 workers) with **~20 internal users** (HR, factory audit, compliance officers), expandable to all 18 factories.

---

### 2. AWS Services Architecture
```
                                 [ CloudFront CDN ]
                                     |         |
                      +--------------+         +--------------+
                      | /* (SPA Web)                          | /api/* (Backend)
                      v                                       v
               [ S3 Frontend ]                     [ Application Load Balancer ]
                                                              |
                                           +------------------+------------------+
                                           | (Private App Subnets)               |
                                    [ EC2 Instance 1 ]                    [ EC2 Instance 2 ]
                                 (t3.medium / Auto Scaling)            (t3.medium / Auto Scaling)
                                           |                                     |
                                           +------------------+------------------+
                                                              | (Port 5432)
                                                              v
                                                   [ RDS PostgreSQL DB ]
                                                 (Multi-AZ in Production)
```

1. **VPC & Networking**:
   - 2 Public Subnets (ALB, NAT Gateways across 2 Availability Zones).
   - 2 Private App Subnets (EC2 backend, Ingestion & Validation batch engine).
   - 2 Private DB Subnets (RDS PostgreSQL isolated with no public internet route).
   - NAT Gateway: 1 NAT GW for DEV/UAT (cost savings); 2 HA NAT GWs for PROD.
2. **Compute**:
   - EC2 behind Application Load Balancer with Auto Scaling Group.
   - dev: 1x `t3.small` (save costs).
   - uat: 1x-2x `t3.medium`.
   - prod: Min 2, Max 4 `t3.medium` (or `t3.large` during monthly payroll cut-off batch processing).
3. **Database**:
   - RDS PostgreSQL (`db.t4g.micro` in Dev, `db.t4g.small` in UAT, `db.t4g.medium` Multi-AZ in Prod).
   - Automated backups, gp3 auto-scaling storage, credentials stored in AWS Secrets Manager.
4. **Frontend & CDN**:
   - S3 Bucket for React/Vue SPA build + CloudFront CDN + Origin Access Control (OAC).
   - Single-domain architecture: CloudFront serves frontend assets on `/` and routes `/api/*` to ALB (eliminates CORS issues).
   - S3 Bucket for Ingestion documents (contractor raw attendance files, payslips).
5. **DNS & Security**:
   - Security Groups enforcing least privilege (ALB -> EC2 -> RDS).
   - AWS Systems Manager (SSM) Session Manager for SSH-less, zero-port-22 management.

---

### 3. Compute Comparison: EC2 vs Kubernetes (EKS) for 20 Users
| Evaluation Factor | EC2 with ASG + ALB (Recommended) | Kubernetes (AWS EKS) |
| :--- | :--- | :--- |
| **Sizing for 20 Users** | 1 instance (Dev), 2 instances (Prod, `t3.medium`) | EKS Control Plane + Min 2-3 worker nodes |
| **Fixed Monthly Cost** | ~\$35 - \$70 / month | ~\$220 / month just for 3 EKS control planes + worker nodes |
| **Operational Overhead** | Low. Managed AMI, standard systemd or Docker container. | High. K8s upgrades, ingress controllers, CNI, cert-manager. |
| **Recommendation** | **Best fit for 1 factory & 20 users.** | Overkill now. Consider only when scaling to all 18 factories with microservices. |

If you **must** use Kubernetes (EKS):
- **Master Nodes**: Fully managed by AWS (EKS Control Plane). You manage 0 master nodes.
- **Worker Nodes**:
  - Dev: 2 nodes of `t3.medium` (4 vCPUs, 8 GB total).
  - UAT: 2 nodes of `t3.medium`.
  - Prod: 3 nodes of `t3.large` or `m6i.large` spread across 3 AZs for High Availability.

---

### 4. How Terraform State Idempotency Works
> **"If I create first then it should not create again if I run the same script. Whatever new resources are added only those should be created."**

Terraform guarantees this behavior out of the box through **declarative state management**:
1. When you run `terraform apply`, Terraform reads your `.tf` files and checks the current real AWS state via AWS APIs.
2. It compares the desired state with the recorded `terraform.tfstate`.
3. If no files changed, Terraform reports: `No changes. Your infrastructure matches the configuration.` It **will never recreate** existing resources.
4. If you add a new resource (e.g. an S3 bucket or another subnet), Terraform creates an execution plan that says `Plan: 1 to add, 0 to change, 0 to destroy.` Only the new resource is provisioned.
5. **Remote Backend with Locking**: Using S3 + DynamoDB (`backend-bootstrap/`) ensures that your state file is locked during runs, preventing accidental overwrites or duplicate creation.

---

### 5. Repository Directory Structure
```
terraform/
├── backend-bootstrap/          # Run ONCE: Creates S3 bucket & DynamoDB lock table
│   └── main.tf
├── modules/                    # 100% Reusable parameterized modules
│   ├── vpc/                    # VPC, 2 public, 2 private app, 2 private db subnets, NAT GW
│   ├── security/               # ALB, EC2, and RDS Security Groups + IAM SSM Profile
│   ├── compute_ec2/            # ALB, Target Group, Launch Template, Auto Scaling Group
│   ├── rds/                    # RDS PostgreSQL, Subnet Group, AWS Secrets Manager
│   └── frontend_s3_cdn/        # S3 Frontend + Ingestion Bucket + CloudFront CDN
└── environments/               # Environment-specific deployments
    ├── dev/                    # Development environment configuration
    │   ├── provider.tf
    │   ├── variables.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── terraform.tfvars
    ├── uat/                    # Pre-production environment configuration
    │   ├── provider.tf
    │   ├── variables.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── terraform.tfvars
    └── prod/                   # Production environment configuration (Multi-AZ HA)
        ├── provider.tf
        ├── variables.tf
        ├── main.tf
        ├── outputs.tf
        └── terraform.tfvars
```

---

### 6. Step-by-Step Execution Guide

#### Step 1: Bootstrap the Remote State Backend (One-time setup)
```bash
cd backend-bootstrap
terraform init
terraform apply
```
This generates:
- S3 Bucket: `britannia-contractor-compliance-tf-state-ap-south-1`
- DynamoDB Table: `britannia-contractor-compliance-tf-locks`

#### Step 2: Enable Remote Backend in Environments
In `environments/dev/provider.tf` (and `uat`, `prod`), uncomment the `backend "s3"` block:
```hcl
backend "s3" {
  bucket         = "britannia-contractor-compliance-tf-state-ap-south-1"
  key            = "environments/dev/terraform.tfstate"
  region         = "ap-south-1"
  dynamodb_table = "britannia-contractor-compliance-tf-locks"
  encrypt        = true
}
```

#### Step 3: Deploy DEV Environment
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

#### Step 4: Deploy UAT and PROD
Repeat for UAT and PROD when ready:
```bash
cd environments/uat
terraform init && terraform apply

cd environments/prod
terraform init && terraform apply
```

