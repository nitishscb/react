pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'react-test-nitish1')
        string(name: 'CLUSTER_NAME', description: 'GKE Cluster Name', defaultValue: 'react-app')
        string(name: 'REGION', description: 'GKE Cluster Region', defaultValue: 'us-central1')
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'react-app2')
        string(name: 'TAG', description: 'Docker Image Tag', defaultValue: 'latest')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/nitishscb/react'
            }
        }

        stage('Authenticate GCP') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'GCP_SA_KEY_FILE', variable: 'KEYFILE')]) {
                        sh "gcloud auth activate-service-account --key-file='${KEYFILE}'"
                        sh "gcloud container clusters get-credentials ${params.CLUSTER_NAME} --region ${params.REGION} --project ${params.PROJECT_ID}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def authenticatedAccount = sh(script: "gcloud auth list --filter=status:ACTIVE --format='value(account)'", returnStdout: true).trim()
                    echo "Authenticated GCP account: ${authenticatedAccount}"

                    buildDockerImage()
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    pushDockerImage()
                }
            }
        }

        stage('Inspect Docker Image') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    sh "docker image inspect gcr.io/react-test-nitish1/${params.IMAGE_NAME}:${params.TAG} --format='{{.Architecture}}'"
                }
            }
        }

        stage('Deploy to GKE') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    sh "gcloud container clusters get-credentials ${params.CLUSTER_NAME} --region ${params.REGION} --project ${params.PROJECT_ID}"
                    sh "kubectl apply -f deployment.yml"
                    sh "kubectl apply -f service.yml"
                }
            }
        }
    }

    post {
        success {
            script {
                emailext(
                    to: 'nitish.seceon@gmail.com',
                    subject: "Build ${currentBuild.fullDisplayName} succeeded",
                    body: "The build ${currentBuild.fullDisplayName} has succeeded."
                )
            }
        }

        always {
            echo 'Pipeline has completed!'
            // Add additional post-build steps here
            // For example, triggering a security scan or notifying security teams
        }
    }
}

def buildDockerImage() {
    sh "/usr/local/bin/docker build -t gcr.io/react-test-nitish1/${params.IMAGE_NAME}:${params.TAG} ."
}

def pushDockerImage() {
    sh "/usr/local/bin/docker push gcr.io/react-test-nitish1/${params.IMAGE_NAME}:${params.TAG}"
}

