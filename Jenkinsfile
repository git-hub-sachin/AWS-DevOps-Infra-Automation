pipeline {
    agent any
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Select the environment to deploy')
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose to apply or destroy the infrastructure')
        string(name: 'GIT_BRANCH', defaultValue: 'multi-aws-infra', description: 'Git branch to use')
    }
    environment {
        AWS_REGION = 'us-west-1'
        ECR_REGISTRY = '296062592493.dkr.ecr.${AWS_REGION}.amazonaws.com'
        ECR_REPO = 'infra-image'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    git branch: "${params.GIT_BRANCH}",
                        credentialsId: 'github-credentials',
                        url: 'https://github.com/git-hub-sachin/AWS-DevOps-Infra-Automation.git'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${ECR_REPO} ."
                    sh "docker tag ${ECR_REPO}:latest ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
                }
            }
        }
        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]){
                    script {
                        sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        sh """
                        docker run --rm \
                            -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                            -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                            -v \$(pwd):/app \
                            ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
                            init
                        """
                    }
                }
            }
        }
        stage('Generate Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def terraformCommand = (params.ACTION == 'apply') ? 'plan' : 'destroy'
                        sh """
                        docker run --rm \
                            -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                            -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                            -v \$(pwd):/app \
                            ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
                            ${terraformCommand} ${params.ENVIRONMENT}
                        """
                    }
                }
            }
        }
        stage('Approve Changes') {
            steps {
                script {
                    input message: "Review the Terraform plan for ${params.ACTION}. Approve to proceed?", ok: "Proceed"
                }
            }
        }
        stage('Execute Terraform Action') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        sh """
                        docker run --rm \
                            -e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID \
                            -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY \
                            -v \$(pwd):/app \
                            ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
                            ${params.ACTION} ${params.ENVIRONMENT}
                        """
                    }
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