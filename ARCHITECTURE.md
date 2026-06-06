# StartTech Application Architecture

## System Overview
Internet
|
[CloudFront CDN]
|
[S3 - Next.js Frontend]
|
[Application Load Balancer]
|
[Auto Scaling Group - Golang Backend EC2]
|
[ElastiCache Redis] [MongoDB Atlas]
|
[CloudWatch Logs]

## Components

### Frontend (Next.js)
- Hosted on AWS S3 as static website
- Delivered via CloudFront CDN
- Environment variables injected at build time
- Communicates with backend via ALB DNS

### Backend (Golang)
- Runs on EC2 instances in private subnets
- Auto Scaling Group (min: 1, max: 3)
- Behind Application Load Balancer
- Connects to MongoDB Atlas and ElastiCache Redis
- Logs to CloudWatch

### Database (MongoDB Atlas)
- Managed MongoDB service
- Free M0 cluster on AWS us-east-1
- Connected via connection string

### Cache (ElastiCache Redis)
- cache.t3.micro instance
- Used for session management and caching
- In private subnet

### Networking
- VPC: 10.0.0.0/16
- Public Subnets: 10.0.1.0/24, 10.0.2.0/24
- Private Subnets: 10.0.3.0/24, 10.0.4.0/24
- NAT Gateway for private subnet internet access

## CI/CD Flow

### Backend Flow
Code Push → GitHub Actions → Go Tests → Docker Build
→ ECR Push → Trivy Scan → ASG Rolling Update → Health Check

### Frontend Flow
Code Push → GitHub Actions → npm install → npm audit
→ next build → S3 sync → CloudFront invalidation

## Security
- EC2 instances in private subnets
- ALB in public subnets
- Security groups with least privilege
- Secrets managed via GitHub Secrets
- IAM roles for EC2 to access CloudWatch and ECR