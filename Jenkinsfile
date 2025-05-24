pipeline {
    agent any

    environment {
        IMAGE_NAME = 'wbrymo/java-ecomm-backend'
    }

    stages {
        stage('Clone Repo') {
            steps {
                sh '''
                    rm -rf java-ecommerce-app || echo "Nothing to delete"
                    git clone https://github.com/wbrymo/java-ecommerce-app.git
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('java-ecommerce-app') {
                    script {
                        def app = docker.build("${IMAGE_NAME}")
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-login') {
                        docker.image("${IMAGE_NAME}").push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'k8s-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@ip-172-31-80-119 "kubectl rollout restart deployment java-backend"
                    '''
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
