pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build your Docker image
                    sh '/usr/local/bin/docker build -t gcr.io/react-test-nitish1/react2:latest .'
                }
            }
        }

        stage('Push to GCP Container Registry') {
            steps {
                script {
                    // Authenticate Docker with GCP Container Registry
                    sh '/Users/nitish.upadhyay@postman.com/Downloads/google-cloud-sdk/bin/gcloud auth configure-docker'
                    
                    // Push the Docker image to GCP Container Registry
                    sh '/usr/local/bin/docker push gcr.io/react-test-nitish1/react2:latest'
                }
            }
        }
    }
}

