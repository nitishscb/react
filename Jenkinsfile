pipeline {
    agent any

    environment {
        // Define environment variables for API_TOKEN and ANOTHER_SECRET
        API_TOKEN = credentials('API_TOKEN')
        ANOTHER_SECRET = credentials('ANOTHER_SECRET')
        // Path to Docker executable
        DOCKER_CMD = "/usr/local/bin/docker"
        // Google Cloud SDK path
        GCLOUD_CMD = "/Users/nitish.upadhyay@postman.com/google-cloud-sdk/bin/gcloud"
        // Docker repository URL
        DOCKER_REPO = "gcr.io/${params.PROJECT_ID}/${params.IMAGE_NAME}:${params.TAG}"
    }

    parameters {
        string(name: 'PROJECT_ID', description: 'GCP Project ID', defaultValue: 'react-test-nitish1', trim: true)
        string(name: 'CLUSTER_NAME', description: 'GKE Cluster Name', defaultValue: 'react-app', trim: true)
        string(name: 'REGION', description: 'GKE Cluster Region', defaultValue: 'us-central1', trim: true)
        string(name: 'IMAGE_NAME', description: 'Docker Image Name', defaultValue: 'react-app2', trim: true)
        string(name: 'TAG', description: 'Docker Image Tag', defaultValue: 'latest', trim: true)
        string(name: 'DOCKERFILE_PATH', description: 'Path to Dockerfile', defaultValue: 'Dockerfile', trim: true)
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
                    // Authenticating GCP
                    withCredentials([file(credentialsId: 'GCP_SA_KEY_FILE', variable: 'KEYFILE')]) {
                        sh "${GCLOUD_CMD} auth activate-service-account --key-file=${KEYFILE}"
                        sh "${GCLOUD_CMD} container clusters get-credentials ${params.CLUSTER_NAME} --region ${params.REGION} --project ${params.PROJECT_ID}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with build arguments from environment variables
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
                    // Push Docker image to the repository
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
                    sh "${DOCKER_CMD} image inspect ${DOCKER_REPO} --format='{{.Architecture}}'"
                }
            }
        }

        stage('Deploy to GKE') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    // Deploy to GKE
                    sh "${GCLOUD_CMD} container clusters get-credentials ${params.CLUSTER_NAME} --region ${params.REGION} --project ${params.PROJECT_ID}"
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
        }
    }
}

def buildDockerImage() {
    def tempDir = "${WORKSPACE}/temp_${new Date().getTime()}"
    sh "mkdir ${tempDir}"

    // Write the Dockerfile with build arguments substituted
    writeFile file: "${tempDir}/Dockerfile", text: "FROM node:14\nARG API_TOKEN\nARG ANOTHER_SECRET\n..."

    // Change to the directory where the Dockerfile is located
    sh "cd ${tempDir}"

    // Build Docker image from the directory where Dockerfile is located
    sh "${DOCKER_CMD} build -t ${DOCKER_REPO} --build-arg API_TOKEN=${MASKED_API_TOKEN} --build-arg ANOTHER_SECRET=${MASKED_ANOTHER_SECRET} ."

    sh "rm -rf ${tempDir}"
}


def pushDockerImage() {
    sh "${DOCKER_CMD} push ${DOCKER_REPO}"
}

