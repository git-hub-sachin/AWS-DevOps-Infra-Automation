#!/bin/bash

set -e

ACTION=$1
ENVIRONMENT=$2

case $ACTION in
  "init")
    terraform init -reconfigure -backend-config="key=${ENVIRONMENT}/terraform.tfstate"
    ;;
  "plan-apply")
    terraform plan -var-file="${ENVIRONMENT}.tfvars" -out=tfplan
    ;;
  "plan-destroy")
    terraform plan -destroy -var-file="${ENVIRONMENT}.tfvars" -out=tfplan
    ;;
  "apply")
    terraform apply "tfplan"
    ;;
  "destroy")
    terraform apply "tfplan"
    ;;
  *)
    echo "Invalid action. Use 'init', 'plan-apply', 'plan-destroy', 'apply', or 'destroy'."
    exit 1
    ;;
esac