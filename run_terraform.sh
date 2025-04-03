#!/bin/bash
# set -e

# ACTION=$1
# ENVIRONMENT=$2

# case $ACTION in
#   "init")
#     terraform init
#     ;;
#   "plan")
#     terraform plan -var-file="${ENVIRONMENT}.tfvars" -out=tfplan
#     ;;
#   "apply")
#     terraform apply "tfplan"
#     ;;
#   "destroy")
#     terraform destroy -var-file="${ENVIRONMENT}.tfvars"
#     ;;
#   *)
#     echo "Invalid action. Use 'init', 'plan', 'apply', or 'destroy'."
#     exit 1
#     ;;
# esac

####################################


# set -e

# ACTION=$1
# ENVIRONMENT=$2

# # S3 backend configuration
# TF_BUCKET="my-terraform-state-docker-image"
# TF_STATE_KEY="terraform.tfstate"
# TF_REGION="us-west-1"

# case $ACTION in
#   "init")
#     terraform init -backend-config="bucket=$TF_BUCKET" \
#                    -backend-config="key=$TF_STATE_KEY" \
#                    -backend-config="region=$TF_REGION"
#     ;;
#   "plan")
#     terraform plan -var-file="${ENVIRONMENT}.tfvars" -out=tfplan
#     ;;
#   "apply")
#     terraform apply "tfplan"
#     ;;
#   "destroy")
#     terraform destroy -var-file="${ENVIRONMENT}.tfvars"
#     ;;
#   *)
#     echo "Invalid action. Use 'init', 'plan', 'apply', or 'destroy'."
#     exit 1
#     ;;
# esac
##############################33


#!/bin/bash
set -e  # Exit script on error

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
    read -p "Are you sure you want to destroy resources in ${ENVIRONMENT}? (yes/no): " CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
      terraform destroy -var-file="${ENVIRONMENT}.tfvars"
    else
      echo "Destroy operation cancelled."
      exit 1
    fi
    ;;
  *)
    echo "Invalid action. Use 'init', 'plan', 'apply', or 'destroy'."
    exit 1
    ;;
esac
