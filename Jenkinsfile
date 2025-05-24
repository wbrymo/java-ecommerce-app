pipeline {
    agent any

    environment {
        IMAGE_NAME = "wbrymo/java-ecomm-backend:latest"
        MAVEN_CACHE = "${env.WORKSPACE}/.m2"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/wbrymo/java-ecommerce-app.git'
            }
        }

        stage('Prepare Maven Cache') {
            steps {
                // Ensure the Maven cache directory exists
                sh 'mkdir -p "$MAVEN_CACHE"'
            }
        }

        stage('Build Docker Image with Maven Cache') {
            steps {
                script {
                    sh """
                        # Pre-fetch Maven dependencies using cache
                        docker run --rm -v "\$PWD:/app" -v "\$MAVEN_CACHE:/root/.m2" -w /app maven:3.8.6-openjdk-11 mvn dependency:go-offline

                        # Build the Docker image (using the working Dockerfile)
                        docker build -t $IMAGE_NAME .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    """
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
