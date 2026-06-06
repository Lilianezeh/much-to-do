#!/bin/bash
set -e
echo "Deploying frontend to S3..."
S3_BUCKET=$(aws s3 ls | grep starttech-frontend | awk '{print $3}')
aws s3 sync Server/MuchToDo/frontend/out/ s3://$S3_BUCKET --delete
echo "Frontend deployed!"