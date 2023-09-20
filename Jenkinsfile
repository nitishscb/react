pipeline {
    agent any

    environment {
        GCP_CREDENTIALS = credentials('nitish-secret')
        GCP_PROJECT_ID = 'react-test-nitish1'
    }

    stages {
        stage('Authenticate and Validate Credentials') {
            steps {
                script {
                    // Write the GCP credentials to a JSON key file
                    writeFile file: 'service-account-key.json', text: "${GCP_CREDENTIALS}"

                    // Authenticate using gcloud and validate the credentials
                    sh '''
                        gcloud auth activate-service-account --key-file=service-account-key.json
                        gcloud config set project ${GCP_PROJECT_ID}
                        gcloud compute instances list --limit=1  # Replace with an appropriate gcloud command for validation
                    '''
                }
            }
        }

        stage('Deploy to GCP') {
            steps {
                // Add steps to deploy to GCP using the authenticated credentials
                sh '''
                    # Example: gcloud compute instances create ...
                    # Use gcloud commands to deploy resources to GCP
                '''
            }
        }

        // Add more stages as needed
    }
}

