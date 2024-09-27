# Project Title: Setup Guide

## Introduction
This guide outlines the steps to set up and deploy a Kubernetes cluster using AWS EKS, PostgreSQL, Helm, and CloudWatch for the coworking project. Follow the instructions below to create the cluster, configure services, and deploy the necessary components.

## Labels
- **Technology**: AWS EKS, PostgreSQL, Helm, Kubernetes
- **Category**: Infrastructure Setup, Cluster Deployment
- **Purpose**: Create and manage an EKS cluster for the MNES project

## Context
This project involves setting up a Kubernetes cluster with PostgreSQL as the database service. The instructions cover creating the cluster, setting up ECR (Elastic Container Registry), deploying PostgreSQL using Helm, seeding data, and configuring AWS CloudWatch for observability.

## Setup Instructions
Open a bash terminal at the root folder of your project and run the following command to create a cluster:

### 1. Create the Cluster
```bash
./scripts/create_cluster.sh proj3-cluster us-east-1
```

### 2. Create ECR repository by following this command below in bash
```bash
./scripts/create_ecr.sh project3-repo us-east-1
```

### 3. Install helm
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prj3 bitnami/postgresql --set primary.persistence.enabled=false
```

### 4. Store local variable to seeding data
```bash
export POSTGRE_SQL="prj3-postgresql"
kubectl port-forward svc/"$POSTGRE_SQL" 5432:5432 &
export POSTGRES_PASSWORD=$(kubectl get secret prj3-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
```

### 5. Run one by one commands are below
```bash
PGPASSWORD="$POSTGRES_PASSWORD"  psql -U postgres -d postgres -h 127.0.0.1 -a -f db/1_create_tables.sql
PGPASSWORD="$POSTGRES_PASSWORD"  psql -U postgres -d postgres -h 127.0.0.1 -a -f db/2_seed_users.sql
PGPASSWORD="$POSTGRES_PASSWORD"  psql -U postgres -d postgres -h 127.0.0.1 -a -f db/3_seed_tokens.sql
```
### 6. Going to AWS Dashboard, create code build, add ENV data, attach policy
```bash
Go to AWS dashboard > Codebuild > Create > Connect with public repository in Github > Add ENV > AWS_DEFAULT_REGION: us-east-1 > ACCOUNT_ID: 758151278751 > Result is codebuild name "prj3-codebuild"
Go to AWS dashboard > IAM > Roles > "prj3-codebuild" > attach policy > Statement.Action: ["ecr*"] > Statement.Resource: ["*"]
```

### 7. Create configmap file and run
```bash
kubectl apply -f deployment/configmap.yaml
```

### 8. Create secret file and run
```bash
kubectl apply -f deployment/secret.yaml
```

### 9. Create deployemnt coworking file and run
```bash
kubectl apply -f deployment/coworking.yaml
```

### 10. Create addon Cloudwatch
```bash
aws iam attach-role-policy \
    --role-name eksctl-prj3-cluster-nodegroup-ng-7-NodeInstanceRole-qS53nAh9FaoD \
    --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
```

### 11. Attach the CloudWatchAgentServerPolicy
```bash
aws eks create-addon --addon-name amazon-cloudwatch-observability --cluster-name prj3-cluster
```
