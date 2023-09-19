pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/nitishscb/react'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build('hyperswitch-server-2:latest', '.')
                    dockerImage.inside {
                        // Any commands you need to run inside the built image
                        sh 'echo "Building inside the Docker image..."'
                    }
                }
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                script {
                    sh 'ansible-playbook deploy.yml'
                }
            }
        }
    }
}
