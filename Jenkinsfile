pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'your-gcp-project-id')
        string(name: 'CLUSTER_NAME', description: 'GKE Cluster Name', defaultValue: 'your-gke-cluster-name')
        string(name: 'REGION', description: 'GKE Cluster Region', defaultValue: 'your-gke-cluster-region')
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'your-image-name')
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
                    sh "/usr/local/bin/docker build -t gcr.io/${params.PROJECT_ID}/${params.IMAGE_NAME}:${params.TAG} ."
                }
            }
        }

        stage('Push Docker Image to GCR') {
            steps {
                script {
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

