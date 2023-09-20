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
                    withCredentials([string(credentialsId: 'GCP_SERVICE_ACCOUNT_JSON', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        // Authenticate with Docker using the Google Application Credentials
                        sh "/usr/local/bin/docker login -u _json_key -p '\$(echo \$GOOGLE_APPLICATION_CREDENTIALS)' https://gcr.io"

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

