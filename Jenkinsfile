pipeline {
    agent any

    parameters {
        string(name: 'project', description: 'GCP Project ID', defaultValue: 'your-project-id')
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
                    // Define the temporary file to store the service account key
                    def tempKeyFile = 'temp-key.json'

                    // Retrieve the GCP service account key from the secret file
                    withCredentials([file(credentialsId: 'key-sa', variable: 'GC_KEY')]) {
                        // Write the service account key to the temporary file
                        writeFile file: tempKeyFile, text: env.GC_KEY

                        // Set the GOOGLE_APPLICATION_CREDENTIALS environment variable to the temporary key file path
                        withEnv(['GOOGLE_APPLICATION_CREDENTIALS' : tempKeyFile]) {
                            // Authenticate with gcloud using the Google Application Credentials
                            sh "gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}"
                            sh "gcloud container clusters get-credentials prod --zone northamerica-northeast1-a --project ${project}"
                        }
                    }

                    // Clean up the temporary key file
                    deleteFile tempKeyFile
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                script {
                    sh "kubectl apply -f your-kubernetes-deployment.yaml"
                }
            }
        }
    }
}

