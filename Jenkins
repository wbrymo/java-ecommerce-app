
pipeline {
  agent any
  stages {
    stage('Clone') {
      steps {
        git 'https://github.com/your-username/ecommerce-backend.git'
      }
    }
    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
    stage('Docker Build & Push') {
      steps {
        sh 'docker build -t wbrymo/ecommerce:v1 .'
        sh 'docker push wbrymo/ecommerce:v1'
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'kubectl apply -f k8s/'
      }
    }
  }
}
