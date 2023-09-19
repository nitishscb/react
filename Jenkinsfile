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
                    // Build the Docker image using the local Docker installation
                    sh '/usr/local/bin/docker build -t hyperswitch-server-2:latest .'
                }
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                script {
                    sh '/opt/homebrew/bin/ansible-playbook deploy.yml'
                }
            }
        }
    }
}
