pipeline {
    agent any

    environment {
        IMAGE_NAME = "wbrymo/java-ecomm-backend:latest"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/wbrymo/java-ecommerce-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                        docker build -t $IMAGE_NAME .
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@ip-172-31-80-119 "kubectl rollout restart deployment java-backend"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Build completed. Cleaning up workspace..."
            cleanWs()
        }
    }
}
