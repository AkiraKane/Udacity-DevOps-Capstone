
pipeline {
     agent any

    environment {
        image_name = "vampire2008/capstone:latest"
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
                    def new_image = docker.build("${image_name}")
                } 
            }
        }
         stage('Security Scan') {
              steps { 
                 aquaMicroscanner imageName: "${image_name}", notCompliesCmd: 'exit 1', onDisallowed: 'ignore', outputFormat: 'html'
              }
         } 

         stage('Integration testing') {
            steps {
                script {
                    def port = 8080
                    new_image.withRun("-p ${port}:80") {
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
                        new_image.push()
                    }
                }
            }
        }
     }
}