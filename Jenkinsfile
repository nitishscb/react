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
                    docker.build('hyperswitch-server-2:latest', '.')
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

