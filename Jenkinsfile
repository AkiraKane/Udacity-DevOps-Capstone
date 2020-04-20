
pipeline {
     agent any

    environment {
        imageName = "vampire2008/capstone:latest"
    }
     stages {
         stage('Build') {
             steps {
                 sh 'echo "Hello There!"'
             }
         }
         stage('Lint HTML') {
              steps {
                  sh 'tidy -q -e ./site/*.html'
              }
         }

         stage('Image Build') {
            steps {
                script {
                    newImage = docker.build("${imageName}")
                } 
            }
        }
         stage('Security Scan') {
              steps { 
                 aquaMicroscanner imageName: "${imageName}", notCompliesCmd: 'exit 1', onDisallowed: 'ignore', outputFormat: 'html'
              }
         } 

         stage('Integration testing') {
            steps {
                script {
                    def port = 8080
                    sh 'docker stop "$(docker ps -q)"'
                    newImage.withRun("-p ${port}:80") {
                        sleep 10
                        sh """
                        curl -v http://localhost:${port}/
                        """
                    }
                }
            }
        }

          stage('Push Image') {
            when { branch "master" }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/', DockerHub) {
                        newImage.push()
                    }
                }
            }
        }
     }
}