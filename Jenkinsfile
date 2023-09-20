pipeline {
    agent any

    parameters {
        file(name: 'GOOGLE_APPLICATION_CREDENTIALS', description: 'Google Application Credentials JSON Key')
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
                    // Read the content of the credentials file
                    def credentialsContent = readFile params.GOOGLE_APPLICATION_CREDENTIALS
                    sh "echo '\$credentialsContent' > /tmp/gcp-key.json"
                    sh "export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcp-key.json"

                    // Build the Docker image
                    sh "/usr/local/bin/docker build -t ${params.IMAGE_NAME}:${params.TAG} ."
                }
            }
        }

        stage('Push Docker Image to GCR') {
            steps {
                script {
                    // Authenticate with GCR
                    sh "/usr/local/bin/docker tag ${params.IMAGE_NAME}:${params.TAG} gcr.io/${params.PROJECT_ID}/${params.IMAGE_NAME}:${params.TAG}"
                    sh "/usr/local/bin/docker push gcr.io/${params.PROJECT_ID}/${params.IMAGE_NAME}:${params.TAG}"
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

