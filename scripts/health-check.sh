#!/bin/bash
ALB_DNS=$(aws elbv2 describe-load-balancers \
  --query "LoadBalancers[?contains(LoadBalancerName, 'starttech')].DNSName" \
  --output text)
curl -sf http://$ALB_DNS/health && echo "Healthy!" || echo "Unhealthy!"