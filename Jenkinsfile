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
                    // Get the GCP service account credentials from Jenkins global credentials
                    def credentials = credentials('nitish-secret')
                    
                    // Use a temporary file to store the service account key
                    def tempKeyFile = File.createTempFile('gcp-key', '.json')
                    tempKeyFile.text = credentials.secret.toString()

                    // Bind the temporary file to an environment variable
                    withCredentials([fileBinding(credentialsId: 'nitish-secret', variable: 'JSON_KEY', 'tempKeyFile')]) {
                        // Authenticate with Docker using the Google Application Credentials
                        sh "/usr/local/bin/docker login -u _json_key -p '\$(cat $JSON_KEY)' https://gcr.io"

                        // Build the Docker image
                        sh "/usr/local/bin/docker build -t ${params.IMAGE_NAME}:${params.TAG} ."

                        // Push the Docker image to Google Container Registry (GCR)
                        sh "/usr/local/bin/docker push ${params.IMAGE_NAME}:${params.TAG}"
                    }

                    // Clean up the temporary file
                    tempKeyFile.delete()
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

