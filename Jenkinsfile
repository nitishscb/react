pipeline {
    agent any

    stages {
        stage('Build and Push Image') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'GCP_SA_KEY_FILE', variable: 'KEYFILE')]) {
                        // Authenticate with Google Cloud using the service account key file
                        sh "gcloud auth activate-service-account --key-file='${KEYFILE}'"

                        // Build and push the Docker image to Google Container Registry
                        sh "docker build -t gcr.io/react-test-nitish1/reactapp2:latest ."
                        sh "docker push gcr.io/react-test-nitish1/reactapp2:latest"
                    }
                }
            }
        }
    }
}

