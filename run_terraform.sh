#!/bin/bash
set -e

ACTION=$1
ENVIRONMENT=$2

case $ACTION in
  "init")
    terraform init
    ;;
  "plan")
    terraform plan -var-file="${ENVIRONMENT}.tfvars" -out=tfplan
    ;;
  "apply")
    terraform apply "tfplan"
    ;;
  "destroy")
    terraform destroy -var-file="${ENVIRONMENT}.tfvars"
    ;;
  *)
    echo "Invalid action. Use 'init', 'plan', 'apply', or 'destroy'."
    exit 1
    ;;
esac