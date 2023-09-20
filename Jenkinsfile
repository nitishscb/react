pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'react-test-nitish1')
        string(name: 'CLUSTER_NAME', description: 'GKE Cluster Name', defaultValue: 'react-app')
        string(name: 'REGION', description: 'GKE Cluster Region', defaultValue: 'us-central1')
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'react-app2')
        string(name: 'TAG', description: 'Docker Image Tag', defaultValue: 'latest')
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
                    // Retrieve the GCP service account key from the secret file
                    def serviceAccountKey = credentials('nitish-secret')

                    // Write the service account key to a temporary file
                    def tempKeyFile = writeFile(file: 'temp-key.json', text: serviceAccountKey)

                    // Set the GOOGLE_APPLICATION_CREDENTIALS environment variable to the temporary key file path
                    withEnv(['GOOGLE_APPLICATION_CREDENTIALS' : tempKeyFile]) {
                        // Authenticate with Docker using the Google Application Credentials
                        sh "/usr/local/bin/docker login -u _json_key -p '\$(cat $GOOGLE_APPLICATION_CREDENTIALS)' https://gcr.io"

                        // Build the Docker image
                        sh "/usr/local/bin/docker build -t ${params.IMAGE_NAME}:${params.TAG} ."

                        // Push the Docker image to Google Container Registry (GCR)
                        sh "/usr/local/bin/docker push ${params.IMAGE_NAME}:${params.TAG}"
                    }

                    // Clean up the temporary key file
                    deleteFile tempKeyFile
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                script {
                    sh "gcloud container clusters get-credentials ${params.CLUSTER_NAME} --region ${params.REGION} --project ${params.PROJECT_ID}"
                    sh "kubectl apply -f your-kubernetes-deployment.yaml"
                }
            }
        }
    }
}

