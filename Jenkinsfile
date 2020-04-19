
pipeline {
     agent any

    environment {
        image_name = "vampire2008/capstone:latest"
    }
     stages {
         stage('Build') {
             steps {
                 sh 'echo "Hello World"'
                 sh '''
                     echo "Multiline shell steps works too"
                     ls -lah
                 '''
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
                 aquaMicroscanner imageName: "${image_name}", notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
              }
         } 

         stage('Integration testing') {
            steps {
                script {
                    def port = 8080
                    apiImage.withRun("-p ${port}:80") {
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