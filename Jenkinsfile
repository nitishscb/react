pipeline {
    agent any

    stages {
        stage('Build and Push Image') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'GCP_SA_KEY_FILE', variable: 'KEYFILE')]) {
			def escapedKeyfile = KEYFILE.replaceAll("'", "\\\\'")
                        sh "/usr/local/bin/docker login -u _json_key -p \"\$(cat '${escapedKeyfile}')\" https://gcr.io"
                        sh "/usr/local/bin/docker build -t gcr.io/react-test-nitish1/reactapp2:latest ."
                        sh "/usr/local/bin/docker push gcr.io/react-test-nitish1/reactapp2:latest"
                    }
                }
            }
        }
    }
}

