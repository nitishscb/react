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
                    def credentialsFile = params.GOOGLE_APPLICATION_CREDENTIALS

                    // Print the file path for debugging
                    echo "Google Application Credentials File: ${credentialsFile}"

                    if (credentialsFile) {
                        // Check if the file exists
                        def fileExists = fileExists(credentialsFile)
                        echo "File exists: ${fileExists}"

                        if (fileExists) {
                            // Print the content of the credentials file
                            def credentialsContent = readFile(credentialsFile)
                            echo "Credentials Content: ${credentialsContent}"
                        } else {
                            error "Credentials file not found at specified path."
                        }
                    } else {
                        error "Google Application Credentials file path parameter is null or empty."
                    }

                    // Authenticate with Docker using the Google Application Credentials
                    sh "/usr/local/bin/docker login -u _json_key -p '\$(cat ${credentialsFile})' https://gcr.io"

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

// Function to check if a file exists
def fileExists(filePath) {
    def file = new File(filePath)
    return file.exists()
}

