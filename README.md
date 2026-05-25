# AWS-VPC-ALB-Auto-Scaling-using-Terraform-Modular-Architecture-

# 📌 Project Overview

This project demonstrates a **production-grade AWS infrastructure** built using **Terraform modular architecture**.

The infrastructure includes:

- Custom VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- EC2 Instance
- AMI Creation
- Launch Template
- Application Load Balancer (ALB)
- Target Group
- Auto Scaling Group (ASG)
- Auto Scaling Policy
- Stress/Capacity Mode

---

# 🏗️ Architecture Diagram

```text
                         Internet
                             │
                        ┌────▼────┐
                        │   ALB   │
                        └────┬────┘
                             │
                    ┌────────▼────────┐
                    │  Target Group   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Auto Scaling    │
                    │     Group       │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  EC2 Instances  │
                    │ (Private Subnet)
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ NAT Gateway     │
                    └────────┬────────┘
                             │
                        ┌────▼────┐
                        │   IGW   │
                        └─────────┘
```

---

# 🌐 Networking Design

## Public Subnet
Resources placed in public subnet:

- ALB
- NAT Gateway

Public Route Table:

```text
0.0.0.0/0 → Internet Gateway
```

---

## Private Subnet
Resources placed in private subnet:

- EC2 Instances
- Auto Scaling Group

Private Route Table:

```text
0.0.0.0/0 → NAT Gateway
```

---

# 🔐 Security Design

## ALB Security Group

Allows:

- HTTP (80) from internet

```text
0.0.0.0/0 → Port 80
```

---

## EC2 Security Group

Allows:

- HTTP only from ALB Security Group

```text
ALB SG → Port 80
```

---

# ⚙️ Core Components

---

## 1. VPC

Custom VPC created for:

- Network isolation
- Security
- Custom subnet design
- Route table management

---

## 2. NAT Gateway

Used to provide outbound internet access to EC2 instances running inside private subnet.

Flow:

```text
Private EC2 → NAT Gateway → IGW → Internet
```

---

## 3. AMI

Custom AMI created from EC2 instance to maintain immutable infrastructure.

AMI contains:

- OS
- Apache setup
- Application configuration

---

## 4. Launch Template

Launch Template acts as blueprint for ASG instances.

Contains:

- AMI ID
- Instance Type
- Security Group
- user_data

---

## 5. Application Load Balancer (ALB)

ALB distributes incoming traffic across healthy EC2 instances.

Features:

- Layer 7 Load Balancer
- Health Checks
- High Availability

---

## 6. Target Group

Target Group:

- Registers EC2 instances
- Performs health checks
- Routes traffic only to healthy instances

---

## 7. Auto Scaling Group (ASG)

ASG responsibilities:

- Maintain desired capacity
- Scale instances automatically
- Replace unhealthy instances
- Self-healing infrastructure

---

# 🔄 Request Flow

```text
User
 ↓
ALB
 ↓
Listener
 ↓
Target Group
 ↓
Healthy EC2 Instance
```

---

# 📦 Launch Template user_data

```hcl
user_data = base64encode(<<-EOF
#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "<h1>Welcome from ASG Instance</h1>" > /var/www/html/index.html

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo "<h2>Instance ID: $INSTANCE_ID</h2>" >> /var/www/html/index.html

EOF
)
```

---

# 📈 Auto Scaling Policy

Implemented:

- Target Tracking Scaling Policy

Behavior:

```text
High CPU → Scale Out
Low CPU → Scale In
```

---

# 🔥 Stress Mode

Implemented capacity stress mode using Terraform variables.

## variables.tf

```hcl
variable "stress_mode" {
  description = "Enable stress mode"
  type        = bool
  default     = false
}
```

---

## Run Stress Mode

```bash
terraform apply -var="stress_mode=true"
```

This increases:

- desired_capacity
- min_size
- max_size

---

# 🧪 Load Testing

ApacheBench used for stress testing.

```bash
ab -n 10000 -c 100 http://<alb_dns>
```

Where:

- `-n` → total requests
- `-c` → concurrent users

---

# 📂 Project Structure

```text
terraform-project/
│
├── main.tf
├── provider.tf
├── variables.tf
│
├── modules/
│   ├── vpc/
│   ├── public_subnet/
│   ├── private_subnet/
│   ├── internet_gateway/
│   ├── public_route_table/
│   ├── private_route_table/
│   ├── nat_gateway/
│   ├── alb_sg/
│   ├── ec2_sg/
│   ├── ec2_instance/
│   ├── ami/
│   ├── launch_template/
│   ├── target_group/
│   ├── alb/
│   └── autoscaling/
```

---

# 🚀 Terraform Commands

## Initialize Terraform

```bash
terraform init
```

---

## Validate Configuration

```bash
terraform validate
```

---

## Plan Infrastructure

```bash
terraform plan
```

---

## Apply Infrastructure

```bash
terraform apply
```

---

## Destroy Infrastructure

```bash
terraform destroy
```

---

# ⚠️ Issues Faced & Fixes

---

## 1. 502 Bad Gateway

### Cause:
Apache not running in ASG instances.

### Fix:
Added user_data in Launch Template.

---

## 2. ALB Requires 2 Subnets

### Cause:
ALB requires multi-AZ deployment.

### Fix:
Created second public subnet.

---

## 3. Invalid AMI Name

### Cause:
Timestamp contains `:`.

### Fix:

```hcl
replace(timestamp(), ":", "-")
```

---

## 4. Signature Expired Error

### Cause:
System time mismatch.

### Fix:

```bash
sudo chronyc makestep
```

---

# 🧠 Key Concepts Learned

- Modular Terraform Design
- AWS Networking
- Public vs Private Subnets
- NAT Gateway Flow
- Route Tables
- ALB + Target Group
- Auto Scaling
- Immutable Infrastructure
- Health Checks
- Stress Testing
- Self-Healing Systems

---

# 📌 Future Enhancements

- HTTPS using ACM
- Route53 Integration
- CloudWatch Monitoring
- CI/CD Pipeline
- Multi-AZ Private Subnets
- WAF Integration

---

# 🏆 Final Outcome

✅ Scalable Infrastructure  
✅ Secure Architecture  
✅ Highly Available System  
✅ Production-Ready Terraform Project  

---

# 👨‍💻 Author

Name - P.HARIHARA VENKATA NAGASAI

ROLE - DevOps Engineer

---

