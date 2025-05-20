pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        DOCKER_IMAGE_NAME = "phonepe"
        DOCKER_TAG = "latest"
    }

    stages {
        stage("Clean") {
            steps {
                sh 'mvn clean'
            }
        }

        stage("Validate") {
            steps {
                sh 'mvn validate'
            }
        }

        stage("Test") {
            steps {
                sh 'mvn test'
            }
        }

        stage("Package") {
            steps {
                sh 'mvn package'
            }
            post {
                success {
                    echo "Build successful"
                }
            }
        }

        stage("Build Docker Image") {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .'
            }
            post {
                success {
                    echo "Docker image built successfully"
                }
                failure {
                    echo "Docker image build failed"
                }
            }
        }

        stage("Docker Login") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'madhand249', passwordVariable: 'madhan249@@@')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage("Push to Docker Hub") {
            steps {
                script {
                    sh """
                    docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} $DOCKER_USER/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    docker push $DOCKER_USER/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    """
                }
            }
            post {
                success {
                    echo "Image pushed to Docker Hub successfully"
                }
                failure {
                    echo "Failed to push image to Docker Hub"
                }
            }
        }

        stage("Remove Local Docker Images") {
            steps {
                sh """
                docker rmi -f $DOCKER_USER/${DOCKER_IMAGE_NAME}:${DOCKER_TAG} || true
                docker rmi -f ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} || true
                """
            }
            post {
                success {
                    echo "Docker images removed locally"
                }
                failure {
                    echo "Failed to remove Docker images locally"
                }
            }
        }

        stage("Stop and Restart Container") {
            steps {
                sh """
                docker rm -f app || true
                docker run -it -d --name app -p 8081:8080 $DOCKER_USER/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                """
            }
            post {
                success {
                    echo "Container restarted successfully"
                }
                failure {
                    echo "Failed to restart container"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful"
        }
        failure {
            echo "Deployment failed"
        }
    }
}
