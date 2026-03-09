// Jenkinsfile - Groovy Pipeline
// Project Structure:
//   app/         → Python Flask application + Dockerfile
//   dev/         → Terraform infrastructure code
pipeline {
    agent any

    parameters {
        choice(
            name: 'TERRAFORM_ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select Terraform action to perform'
        )
    }

    environment {
        AWS_REGION            = "us-east-1"
        AWS_ACCOUNT_ID        = "204298492808"
        ECR_REPO_NAME         = "bhagyashil/web"
        IMAGE_TAG             = "${env.BUILD_NUMBER}"
        ECR_REGISTRY          = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        ECR_IMAGE_URI         = "${ECR_REGISTRY}/${ECR_REPO_NAME}"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {

        // ─────────────────────────────────────────
        // STAGE 1: Checkout Code
        // ─────────────────────────────────────────
        stage('Checkout Code') {
            steps {
                echo "========== Checking out code from GitLab =========="
                checkout scm
                echo "Code checkout successful!"
            }
        }

        // ─────────────────────────────────────────
        // STAGE 2: ECR Login
        // ─────────────────────────────────────────
        stage('ECR Login') {
            when {
                expression { params.TERRAFORM_ACTION != 'destroy' }
            }
            steps {
                sh """
                    echo "========== Logging in to Amazon ECR =========="
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    echo "ECR Login successful!"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 3: Docker Build
        // ─────────────────────────────────────────
        stage('Docker Build') {
            when {
                expression { params.TERRAFORM_ACTION != 'destroy' }
            }
            steps {
                sh """
                    echo "========== Building Docker Image =========="
                    docker build -t ${ECR_REPO_NAME}:${IMAGE_TAG} ./app
                    docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_IMAGE_URI}:${IMAGE_TAG}
                    docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_IMAGE_URI}:latest
                    echo "Docker image built: ${ECR_IMAGE_URI}:${IMAGE_TAG}"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 4: Push to ECR
        // ─────────────────────────────────────────
        stage('Push to ECR') {
            when {
                expression { params.TERRAFORM_ACTION != 'destroy' }
            }
            steps {
                sh """
                    echo "========== Pushing Image to ECR =========="
                    docker push ${ECR_IMAGE_URI}:${IMAGE_TAG}
                    docker push ${ECR_IMAGE_URI}:latest
                    echo "Image pushed: ${ECR_IMAGE_URI}:${IMAGE_TAG}"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 5: Terraform Init
        // ─────────────────────────────────────────
        stage('Terraform Init') {
            steps {
                sh """
                    echo "========== Terraform Init =========="
                    cd dev
                    terraform init
                    echo "Terraform init successful!"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 6: Terraform Plan
        // ─────────────────────────────────────────
        stage('Terraform Plan') {
            when {
                expression { params.TERRAFORM_ACTION == 'plan' || params.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                sh """
                    echo "========== Terraform Plan =========="
                    cd dev
                    terraform plan \
                        -var="ecr_image_uri=${ECR_IMAGE_URI}" \
                        -var="image_tag=${IMAGE_TAG}" \
                        -out=tfplan
                    echo "Terraform plan successful!"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 7: Terraform Apply
        // ─────────────────────────────────────────
        stage('Terraform Apply') {
            when {
                expression { params.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                sh """
                    echo "========== Terraform Apply =========="
                    cd dev
                    terraform apply -auto-approve tfplan
                    echo "Infrastructure deployed successfully!"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 8: Terraform Destroy
        // ─────────────────────────────────────────
        stage('Terraform Destroy') {
            when {
                expression { params.TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                sh """
                    echo "========== Terraform Destroy =========="
                    cd dev
                    terraform destroy \
                        -var="ecr_image_uri=${ECR_IMAGE_URI}" \
                        -var="image_tag=${IMAGE_TAG}" \
                        -auto-approve
                    echo "Infrastructure destroyed successfully!"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 9: Deploy to ECS
        // ─────────────────────────────────────────
        stage('Deploy to ECS') {
            when {
                expression { params.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                sh """
                    echo "========== Deploying to ECS =========="
                    aws ecs update-service \
                        --cluster gitlab-ecs-cluster \
                        --service gitlab-ecs-service \
                        --force-new-deployment \
                        --region ${AWS_REGION}
                    echo "ECS deployment triggered!"
                """
            }
        }

        // ─────────────────────────────────────────
        // STAGE 10: Cleanup
        // ─────────────────────────────────────────
        stage('Cleanup') {
            when {
                expression { params.TERRAFORM_ACTION != 'destroy' }
            }
            steps {
                sh """
                    echo "========== Cleanup Docker Images =========="
                    docker rmi ${ECR_IMAGE_URI}:${IMAGE_TAG} || true
                    docker rmi ${ECR_IMAGE_URI}:latest || true
                    docker rmi ${ECR_REPO_NAME}:${IMAGE_TAG} || true
                    echo "Cleanup done!"
                """
            }
        }
    }

    post {
        success {
            echo """
            ✅ ================================
            ✅ PIPELINE SUCCESS!
            ✅ Action  : ${params.TERRAFORM_ACTION}
            ✅ Image   : ${ECR_IMAGE_URI}:${IMAGE_TAG}
            ✅ Cluster : gitlab-ecs-cluster
            ✅ Service : gitlab-ecs-service
            ✅ ================================
            """
        }
        failure {
            echo """
            ❌ ================================
            ❌ PIPELINE FAILED!
            ❌ Action  : ${params.TERRAFORM_ACTION}
            ❌ Check logs above for errors
            ❌ ================================
            """
        }
        always {
            echo "Pipeline finished - Build #${env.BUILD_NUMBER} - Action: ${params.TERRAFORM_ACTION}"
        }
    }
}