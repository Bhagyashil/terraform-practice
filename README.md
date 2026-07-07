# 🚀 Terraform AWS Infrastructure with Jenkins CI/CD

This project demonstrates Infrastructure as Code (IaC) using Terraform together with a Jenkins CI/CD pipeline to automatically provision AWS infrastructure and deploy a Dockerized Python Flask application.

---

## 📌 Project Overview

This project automates:

- AWS Infrastructure Provisioning
- Docker Image Build
- Jenkins CI/CD Pipeline
- Amazon ECS Deployment
- Infrastructure Automation using Terraform

---

## 📂 Repository Structure

```
terraform-practice/

├── app/
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   └── templates/
│
├── dev/
│   ├── provider.tf
│   ├── vpc.tf
│   ├── subnet.tf
│   ├── igw.tf
│   ├── route.tf
│   ├── security-group.tf
│   ├── alb.tf
│   ├── ecs.tf
│   ├── asg.tf
│   └── output.tf
│
├── Jenkinsfile
└── README.md
```

---

## 🚀 Technologies

- Terraform
- AWS
- ECS
- EC2
- Application Load Balancer
- Auto Scaling
- VPC
- Docker
- Jenkins
- GitHub
- Python Flask

---

## AWS Services Used

- Amazon VPC
- Public Subnets
- Internet Gateway
- Route Tables
- Security Groups
- ECS Cluster
- ECS Service
- EC2
- Auto Scaling Group
- Application Load Balancer
- IAM

---

## CI/CD Workflow

```
GitHub
    │
    ▼
 Jenkins
    │
Terraform Init
    │
Terraform Plan
    │
Terraform Apply
    │
Docker Build
    │
Push Image
    │
Deploy to ECS
    │
Application Running
```

---

## Author

**Bhagyashil Bhendare**

DevOps Engineer

Nagpur, India
