#! /bin/bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prj3 bitnami/postgresql --set primary.persistence.enabled=false
#helm uninstall prj3

export POSTGRE_SQL="prj3-postgresql"
kubectl port-forward svc/"$POSTGRE_SQL" 5432:5432 &

# kubectl get secret prj3-postgresql -o jsonpath="{.data.postgres-password}"
export POSTGRES_PASSWORD=$(kubectl get secret prj3-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

# run one by one commands are below
#PGPASSWORD="$POSTGRES_PASSWORD"  psql -U postgres -d postgres -h 127.0.0.1 -a -f db/1_create_tables.sql
#PGPASSWORD="$POSTGRES_PASSWORD"  psql -U postgres -d postgres -h 127.0.0.1 -a -f db/2_seed_users.sql
#PGPASSWORD="$POSTGRES_PASSWORD"  psql -U postgres -d postgres -h 127.0.0.1 -a -f db/3_seed_tokens.sql

# 43ej384YOP
# NDNlajM4NFlPUA==

export DB_USERNAME="postgres"
export DB_PASSWORD="43ej384YOP"
export DB_HOST="127.0.0.1"
export DB_PORT="5432"
export DB_NAME="postgres"

# ENV DB_USERNAME=postgres
# ENV DB_PASSWORD=43ej384YOP
# ENV DB_HOST=127.0.0.1
# ENV DB_PORT=5432
# ENV DB_NAME=postgres

docker build -t coworking .
docker tag coworking:latest 758151278751.dkr.ecr.us-east-1.amazonaws.com/project3-repo:latest
docker push 758151278751.dkr.ecr.us-east-1.amazonaws.com/project3-repo:latest

# psql -h 127.0.0.1 -U postgres -W -d postgres

# curl 127.0.0.1:5432/api/reports/daily_usage

kubectl get secret --namespace default prj3-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 758151278751.dkr.ecr.us-east-1.amazonaws.com