pipeline {
    agent any

    stages {
        stage('Build and Push Image') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'GCP_SA_KEY_FILE', variable: 'KEYFILE')]) {
                        // Authenticate with Google Cloud using the service account key file
                        sh "/Users/nitish.upadhyay@postman.com/Downloads/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file='${KEYFILE}'"

                        // Build and push the Docker image to Google Container Registry
                        sh "/usr/local/bin/docker build -t gcr.io/react-test-nitish1/reactapp2:latest ."
                        sh "/usr/local/bin/docker push gcr.io/react-test-nitish1/reactapp2:latest"
                    }
                }
            }
        }
    }
}

