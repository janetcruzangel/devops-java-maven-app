#!/user/bin/env groovy

pipeline {
    agent any

    stages {
        
        stage("test") {
            steps {
                script {
                    echo "testing the application..."

                }
            }
        }

        stage("build") {
            steps {
                script {
                    echo "Building the application"
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    sshagent(['ec2-server-key']) {
                        // define a variable holding docker command to be executed on the EC2 server
                        def dockerCmd = 'docker run -d -p 3080:3080 janetcruzangel/demo-app:1.0' 
                        // To suppress the SSH pop up. Update the ip public value as needed
                        // For groovy, in order to use the value of a variable, double quotes must be used
                        // This scripts assumes docker login has been already executed in the EC2 instance and Firewall allows traffic to 3080
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.137.154.143 ${dockerCmd}"
                    }
                }
            }
        }
    }
}
