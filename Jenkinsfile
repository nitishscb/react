pipeline {
    agent {
        docker {
            image 'docker:latest'  // Use the Docker image as the agent
            args '-v $HOME:/home -w /home'  // Mount home directory and set working directory
        }
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/nitishscb/react'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t hyperswitch-server-2:latest .'
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
