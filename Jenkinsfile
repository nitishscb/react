pipeline {
    agent any

    parameters {
        file(name: 'GOOGLE_APPLICATION_CREDENTIALS', description: 'Google Application Credentials JSON Key', defaultValue: 'react-test-nitish1')
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'react-test-nitish1')
        string(name: 'CLUSTER_NAME', description: 'GKE Cluster Name', defaultValue: 'react-app')
        string(name: 'REGION', description: 'GKE Cluster Region', defaultValue: 'us-central1')
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'gcr.io/react-test-nitish1/react-app2')
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
                    def credentialsContent = readFile params.GOOGLE_APPLICATION_CREDENTIALS
                    sh "echo '\$credentialsContent' > /tmp/gcp-key.json"
                    sh "export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcp-key.json"

                    // Authenticate with Docker using the Google Application Credentials
                    sh "/usr/local/bin/docker login -u _json_key -p '\$(cat /tmp/gcp-key.json)' https://gcr.io"

                    // Build the Docker image
                    sh "/usr/local/bin/docker build -t ${params.IMAGE_NAME}:${params.TAG} ."

                    // Push the Docker image to Google Container Registry (GCR)
                    sh "/usr/local/bin/docker push ${params.IMAGE_NAME}:${params.TAG}"
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

