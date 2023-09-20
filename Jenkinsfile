pipeline {
    agent any
    
    environment {
        GCP_SA_KEY_FILE = credentials('GCP_SA_KEY_FILE') // Retrieve the GCP service account key from credentials
        GOOGLE_APPLICATION_CREDENTIALS = "${env.WORKSPACE}/gcp-sa-key.json" // Path to save the key file within the Jenkins workspace
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code
                checkout scm
            }
        }
        
        stage('Setup Google Cloud SDK') {
            steps {
                script {
                    // Set up the Google Cloud SDK
                    sh """
                        echo ${GCP_SA_KEY_FILE} > ${GOOGLE_APPLICATION_CREDENTIALS}
                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
                    """
                }
            }
        }
        
        // Add more stages for your build, test, deploy, etc.
    }
    
    post {
        always {
            // Clean up the Google Cloud SDK authentication file
            deleteFile(file: GOOGLE_APPLICATION_CREDENTIALS)
        }
    }
}

