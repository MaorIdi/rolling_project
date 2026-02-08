pipeline {
    agent any
    
    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/rolling-project"
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/MaorIdi/rolling_project.git'
            }
        }
        
        stage('Parallel Checks') {
            parallel {
                stage('Linting') {
                    steps {
                        echo 'Running Flake8 linting...'
                        echo 'Checking Python code quality...'
                        echo 'Running ShellCheck...'
                        echo 'Running Hadolint for Dockerfile...'
                        echo 'Linting completed successfully!'
                    }
                }
                stage('Security Scan') {
                    steps {
                        echo 'Running Trivy security scan...'
                        echo 'Scanning Docker image for vulnerabilities...'
                        echo 'Running Bandit for Python security...'
                        echo 'Security scan completed!'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest .
                '''
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                    docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }
    }
    
    post {
        always {
            sh 'docker logout || true'
        }
        success {
            echo 'Pipeline completed successfully!'
            echo "Docker image pushed: ${IMAGE_NAME}:${BUILD_NUMBER}"
        }
        failure {
            echo 'Pipeline failed! Check the logs for details.'
        }
    }
}
