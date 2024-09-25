#! /bin/bash
CLUSTER_NAME=$1
REGION=$2
eksctl create cluster --name "$CLUSTER_NAME" --region="$REGION" --nodes-min=2 --nodes-max=3
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"