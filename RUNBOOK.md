# StartTech Application Runbook

## Health Checks

### Check Backend Health
```bash
curl http://starttech-alb-9595592.us-east-1.elb.amazonaws.com/health
```

Expected response:
```json
{"cache":"disabled","database":"ok"}
```

### Check All Services
```bash
bash scripts/health-check.sh
```

## Deployment

### Deploy Backend
```bash
bash scripts/deploy-backend.sh
```

### Deploy Frontend
```bash
bash scripts/deploy-frontend.sh
```

### Rollback
```bash
bash scripts/rollback.sh
```

## Troubleshooting

### Backend Not Responding
1. Check ALB target group health in AWS Console
2. Check EC2 instance logs in CloudWatch
3. SSH into EC2 and check Docker container:
```bash
docker logs muchtodo-backend
docker ps
```

### Database Connection Failed
1. Check MongoDB Atlas cluster status
2. Verify MONGO_URI environment variable
3. Check network access in Atlas (IP whitelist)

### High CPU Alert
1. Check CloudWatch metrics
2. ASG will auto-scale up if CPU > 80%
3. Manual scale up:
```bash
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name starttech-asg \
  --desired-capacity 2
```

## Monitoring

### View Backend Logs
```bash
aws logs tail /starttech/backend --follow
```

### View CloudWatch Dashboard
Go to AWS Console → CloudWatch → Dashboards

## Emergency Contacts
- AWS Support: https://console.aws.amazon.com/support
- MongoDB Atlas Support: https://cloud.mongodb.com/support