pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'your-project-id')
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'gcr.io/your-project-id/your-image')
        string(name: 'TAG', description: 'Docker Image Tag', defaultValue: 'latest')
        string(name: 'GCP_SERVICE_ACCOUNT_JSON_BASE64', description: 'Base64 encoded Google Service Account JSON Key')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def credentialsJson = sh(script: "echo ${params.GCP_SERVICE_ACCOUNT_JSON_BASE64} | base64 --decode", returnStdout: true).trim()
                    def credentialsFile = writeCredentialsToFile(credentialsJson)

                    // Authenticate with Docker using the Google Application Credentials
                    sh "/usr/local/bin/docker login -u _json_key -p '\$(cat ${credentialsFile})' https://gcr.io"

                    // Build the Docker image
                    sh "/usr/local/bin/docker build -t ${params.IMAGE_NAME}:${params.TAG} ."

                    // Push the Docker image to Google Container Registry (GCR)
                    sh "/usr/local/bin/docker push ${params.IMAGE_NAME}:${params.TAG}"
                }
            }
        }

        // Add other stages as needed
    }
}

def writeCredentialsToFile(credentialsJson) {
    def credentialsFile = "${env.WORKSPACE}/gcp-key.json"
    writeFile file: credentialsFile, text: credentialsJson
    return credentialsFile
}

