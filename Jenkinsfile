pipeline {
    agent any
    
    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        IMAGE_NAME = 'maoridi/rolling-project'
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
                        sh '''
                            pip3 install -q flake8
                            flake8 python/ --select=E9,F63,F7,F82 --show-source --statistics
                            flake8 python/ --exit-zero --max-complexity=10 --max-line-length=127 --statistics
                        '''
                        sh 'shellcheck scripts/*.sh || true'
                        sh 'docker run --rm -i hadolint/hadolint < Dockerfile || true'
                    }
                }
                stage('Security Scan') {
                    steps {
                        sh '''
                            pip3 install -q bandit
                            bandit -r python/ -f txt || true
                        '''
                        sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 0 --severity HIGH,CRITICAL ${IMAGE_NAME}:latest || true'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest .'
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
                    docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }
        
        stage('Deploy for Testing') {
            steps {
                sh '''
                    docker stop rolling-test || true
                    docker rm rolling-test || true
                    docker run -d --name rolling-test -p 5000:5001 ${IMAGE_NAME}:latest
                    sleep 5
                    curl -f http://localhost:5000 || exit 1
                '''
            }
            post {
                always {
                    sh 'docker stop rolling-test || true'
                    sh 'docker rm rolling-test || true'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}