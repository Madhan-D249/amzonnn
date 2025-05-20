pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment{
        DOCKERHUB_USERNAME = "madhand249"
    }
    stages {
        stage("clean") {
            steps {
                sh 'mvn clean'
            }
        }
        stage("validate") {
            steps {
                sh 'mvn validate'
            }
        }
        stage("test") {
            steps {
                sh 'mvn test'
            }
        }
        stage("package") {
            steps {
                sh 'mvn package'
            }
            post {
                success {
                    echo "build successfull"
                }
            }
        }
        stage("build docker images") {
            steps {
                sh 'docker build -t phonepe .'
            }
            post {
                success{
                    echo "image build successfully"
                }
                failure{
                    echo "image not built"
                }
            }
        }
        stage("push to docker hub"){
            steps{
                script {
                    sh"""
                    docker tag phonepe ${DOCKERHUB_USERNAME}/phonepe
                    docker push ${DOCKERHUB_USERNAME}/phonepe
                    """
                }
                post {
                success{
                    echo "push is get success"
                }
                failure{
                    echo "pushing is failure"
                }
            
            }
                
        }
        stage("remove docker image locally")
        {
            steps{
                sh"""
                docker rmi -f ${DOCKERHUB_USERNAME}/phonepe
                docker rmi -f phonepe
                """
            }
            post {
                success{
                    echo "remove sucess"
                }
                failure{
                    echo "remove is failure"
                }
            }
        }
        stage("stop and restart"){
            steps {
                sh"""
                docker rm -f app
                docker run -it -d --name app -p 8081:8080 ${DOCKERHUB_USERNAME}/phonepe
                """
            }
            post {
                success{
                    echo "i stoped"
                }
                failure{
                    echo "failure to start"
                }
            }
        }
    }
    post {
        success {
            echo "deployemnt successfull"
        }
        failure {
            echo "deployment is failure"
        }
    }
}