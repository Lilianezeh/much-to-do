#!/bin/bash
echo "Deploying MuchToDo to Kubernetes..."

# Load image into Kind cluster
echo "Loading Docker image into Kind..."
kind load docker-image muchtodo-backend:latest --name muchtodo-cluster

# Apply all manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/ingress.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod \
  -l app=mongodb \
  -n muchtodo \
  --timeout=120s

kubectl wait --for=condition=ready pod \
  -l app=muchtodo-backend \
  -n muchtodo \
  --timeout=120s

echo ""
echo "Deployment complete! Pod status:"
kubectl get pods -n muchtodo
echo ""
echo "Services:"
kubectl get svc -n muchtodo