pipeline {
  agent any

  environment {
    IMAGE_TAG = 'latest'
    ECR_IMAGE = '156916773321.dkr.ecr.ap-south-1.amazonaws.com/sree-jenkins:latest'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/main']],
          userRemoteConfigs: [[
            url: 'https://github.com/Sedin-Sreekanth/buggy-app-jenkins.git',
            credentialsId: 'gitsree'
          ]]
        ])
      }
    }

    stage('Docker Login to ECR') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'AWS_SESSION_TOKEN', variable: 'AWS_SESSION_TOKEN'),
          string(credentialsId: 'AWS_REGION', variable: 'AWS_REGION'),
          string(credentialsId: 'ECR_REGISTRY', variable: 'ECR_REGISTRY')
        ]) {
          sh '''
          aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t 156916773321.dkr.ecr.ap-south-1.amazonaws.com/sree-jenkins:latest .
        '''
      }
    }

    stage('Generate .env Files') {
      steps {
        withCredentials([
          string(credentialsId: 'DB_PASSWORD', variable: 'DB_PASSWORD'),
          string(credentialsId: 'DB_USER', variable: 'DB_USER'),
          string(credentialsId: 'DB_NAME', variable: 'DB_NAME'),
          string(credentialsId: 'DB_HOST', variable: 'DB_HOST'),
          string(credentialsId: 'RAILS_ENV', variable: 'RAILS_ENV'),
          string(credentialsId: 'SECRET_KEY_BASE', variable: 'SECRET_KEY_BASE'),
          string(credentialsId: 'MYSQL_PORT', variable: 'MYSQL_PORT')
        ]) {
          script {
            echo "Generating .env file"
            writeFile file: '.env', text: """
MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
MYSQL_DATABASE=${DB_NAME}
MYSQL_HOST=${DB_HOST}
MYSQL_PORT=3306
SECRET_KEY_BASE=${SECRET_KEY_BASE}
RAILS_ENV=${RAILS_ENV}
ECR_IMAGE=${ECR_IMAGE}
"""
          }
        }
      }
    }

    stage('Push Image to ECR') {
      steps {
        sh '''
        # docker push 156916773321.dkr.ecr.ap-south-1.amazonaws.com/sree-jenkins:latest
        '''
      }
    }

    stage('Run with Docker Compose') {
      steps {
        sh '''
        sudo apt update
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        docker-compose version
        docker-compose up -d
        '''
      }
    }
  }
}
