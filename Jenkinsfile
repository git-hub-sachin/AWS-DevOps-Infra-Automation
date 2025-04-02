pipeline {
    agent any
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Select the environment to deploy')
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose to apply or destroy the infrastructure')
    }
    environment {
        AWS_REGION = 'us-west-1'
        ECR_REGISTRY = '296062592493.dkr.ecr.${AWS_REGION}.amazonaws.com'
        ECR_REPO = 'infra-image'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                    """
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh """
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=\${AWS_ACCESS_KEY_ID} \
                        -e AWS_SECRET_ACCESS_KEY=\${AWS_SECRET_ACCESS_KEY} \
                        ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
                        init
                    """
                }
            }
        }
        stage('Generate Terraform Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    sh """
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=\${AWS_ACCESS_KEY_ID} \
                        -e AWS_SECRET_ACCESS_KEY=\${AWS_SECRET_ACCESS_KEY} \
                        -v \$(pwd):/app \
                        ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
                        plan ${params.ENVIRONMENT}
                    """
                }
            }
        }
        stage('Approve Changes') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    input message: "Review the Terraform plan. Approve to apply changes?", ok: "Apply"
                }
            }
        }
        stage('Execute Terraform Action') {
            steps {
                script {
                    sh """
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=\${AWS_ACCESS_KEY_ID} \
                        -e AWS_SECRET_ACCESS_KEY=\${AWS_SECRET_ACCESS_KEY} \
                        -v \$(pwd):/app \
                        ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
                        ${params.ACTION} ${params.ENVIRONMENT}
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}