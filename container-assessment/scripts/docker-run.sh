#!/bin/bash
echo "Starting MuchToDo with Docker Compose..."
docker compose up --build -d
echo "Waiting for services to start..."
sleep 10
docker compose ps
echo ""
echo "App running at: http://localhost:8080"
echo "Health check: http://localhost:8080/health"