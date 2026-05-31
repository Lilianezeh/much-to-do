# MuchToDo - Container Assessment

## Overview
This project containerizes the MuchToDo Golang backend API using Docker and deploys it to a local Kubernetes cluster using Kind.

## Prerequisites
- Docker Desktop (running)
- Kind v0.22+
- kubectl v1.29+
- Git Bash or WSL

## Project Structure
container-assessment/
├── <application-code>
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── kubernetes/
│   ├── namespace.yaml
│   ├── mongodb/
│   │   ├── mongodb-secret.yaml
│   │   ├── mongodb-configmap.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-deployment.yaml
│   │   └── mongodb-service.yaml
│   ├── backend/
│   │   ├── backend-secret.yaml
│   │   ├── backend-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   └── ingress.yaml
├── scripts/
│   ├── docker-build.sh
│   ├── docker-run.sh
│   ├── k8s-deploy.sh
│   └── k8s-cleanup.sh
└── README.md

## Phase 1: Docker Setup

### Build the Docker Image
```bash
bash scripts/docker-build.sh
# or
docker build -t muchtodo-backend:latest .
```

### Run with Docker Compose
```bash
bash scripts/docker-run.sh
# or
docker compose up -d
```

### Test the Application
```bash
# Health check
curl http://localhost:8080/health

# Ping
curl http://localhost:8080/ping

# API root
curl http://localhost:8080/
```

### Stop Docker Compose
```bash
docker compose down
```

## Phase 2: Kubernetes Deployment

### Step 1: Create Kind Cluster
```bash
kind create cluster --name muchtodo-cluster
kubectl cluster-info
```

### Step 2: Load Docker Image into Kind
```bash
kind load docker-image muchtodo-backend:latest --name muchtodo-cluster
```

### Step 3: Deploy to Kubernetes
```bash
bash scripts/k8s-deploy.sh
```

### Step 4: Verify Deployment
```bash
# Check all resources
kubectl get all -n muchtodo

# Check pods
kubectl get pods -n muchtodo

# Check services
kubectl get svc -n muchtodo

# Check ingress
kubectl get ingress -n muchtodo
```

### Step 5: Access the Application

Via NodePort:
```bash
curl http://localhost:30080/health
curl http://localhost:30080/ping
```

### Step 6: Cleanup
```bash
bash scripts/k8s-cleanup.sh
kind delete cluster --name muchtodo-cluster
```

## Environment Variables

| Variable | Description | Default |
|---|---|---|
| PORT | Server port | 8080 |
| MONGO_URI | MongoDB connection string | - |
| DB_NAME | Database name | much_todo_db |
| JWT_SECRET_KEY | JWT signing key | - |
| JWT_EXPIRATION_HOURS | Token expiry in hours | 72 |
| ENABLE_CACHE | Enable Redis caching | false |
| LOG_LEVEL | Logging level | INFO |
| LOG_FORMAT | Log format (json/text) | json |

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | /health | Health check |
| GET | /ping | Ping test |
| GET | / | Welcome message |
| POST | /api/users/register | Register user |
| POST | /api/users/login | Login user |
| GET | /api/todos | Get all todos |
| POST | /api/todos | Create todo |
| PUT | /api/todos/:id | Update todo |
| DELETE | /api/todos/:id | Delete todo |

## Troubleshooting

**Docker build fails with Go version error:**
```bash
# Make sure GOTOOLCHAIN=auto is set in Dockerfile
ENV GOTOOLCHAIN=auto
```

**Kind cluster creation fails:**
```bash
# Make sure Docker Desktop is running
docker info
```

**Pods not starting:**
```bash
kubectl describe pod -n muchtodo
kubectl logs -n muchtodo <pod-name>
```