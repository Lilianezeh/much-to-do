# StartTech Application

## Overview
Full-stack application with Golang backend and Next.js frontend, deployed on AWS with CI/CD pipelines.

## Repository Structure
starttech-application/
├── .github/workflows/
│   ├── frontend-ci-cd.yml    # React build and S3 deployment
│   └── backend-ci-cd.yml     # Docker build and EC2 deployment
├── Server/MuchToDo/
│   ├── frontend/             # Next.js frontend
│   └── backend/              # Golang backend
├── container-assessment/     # Docker and Kubernetes setup
├── scripts/
│   ├── deploy-frontend.sh
│   ├── deploy-backend.sh
│   ├── health-check.sh
│   └── rollback.sh
└── README.md

## Infrastructure
- **Frontend**: Next.js hosted on S3
- **Backend**: Golang API on EC2 with Auto Scaling
- **Database**: MongoDB Atlas
- **Cache**: ElastiCache Redis
- **Load Balancer**: ALB at `starttech-alb-9595592.us-east-1.elb.amazonaws.com`

## CI/CD Pipelines

### Backend Pipeline
Triggered on push to `main` or `feature/backend-only`:
1. Run Go tests
2. Security scan with gosec
3. Build and push Docker image to ECR
4. Scan image with Trivy
5. Deploy via ASG rolling update
6. Health check

### Frontend Pipeline
Triggered on push to `main` or `feature/backend-only`:
1. Install Node.js dependencies
2. Security audit
3. Build Next.js app
4. Deploy to S3
5. Invalidate CloudFront cache

## Required GitHub Secrets
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
MONGO_URI
JWT_SECRET
S3_BUCKET
NEXT_PUBLIC_API_URL

## Local Development
```bash
# Backend
cd Server/MuchToDo
go run cmd/api/main.go

# Frontend
cd Server/MuchToDo/frontend
npm install
npm run dev

# Docker
cd container-assessment
docker compose up -d
```

## Health Check
```bash
bash scripts/health-check.sh
```trigger workflow
