#!/bin/bash
echo "Building MuchToDo Docker image..."
docker build -t muchtodo-backend:latest .
echo "Build complete!"
docker images | grep muchtodo