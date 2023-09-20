pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'your-project-id')
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'gcr.io/your-project-id/your-image')
        string(name: 'TAG', description: 'Docker Image Tag', defaultValue: 'latest')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def credentialsJson = credentials('react-test-nitish1')

                    // Authenticate with Docker using the Google Application Credentials
                    withCredentials([string(credentialsId: 'react-test-nitish1', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "/usr/local/bin/docker login -u _json_key -p '\$(echo ${credentialsJson})' https://gcr.io"

                        // Build the Docker image
                        sh "/usr/local/bin/docker build -t ${params.IMAGE_NAME}:${params.TAG} ."

                        // Push the Docker image to Google Container Registry (GCR)
                        sh "/usr/local/bin/docker push ${params.IMAGE_NAME}:${params.TAG}"
                    }
                }
            }
        }

        // Add other stages as needed
    }
}

