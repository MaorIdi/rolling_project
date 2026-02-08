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
                        sh '''
                            pip install flake8 --quiet
                            flake8 python/ --max-line-length=120 --ignore=E501,W503 || true
                        '''
                        echo 'Running Hadolint for Dockerfile...'
                        sh '''
                            hadolint Dockerfile || true
                        '''
                        echo 'Linting completed!'
                    }
                }
                stage('Security Scan') {
                    steps {
                        echo 'Running Bandit for Python security...'
                        sh '''
                            pip install bandit --quiet
                            bandit -r python/ -f txt || true
                        '''
                        echo 'Running Trivy security scan...'
                        sh '''
                            trivy fs --severity HIGH,CRITICAL --exit-code 0 .
                        '''
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
