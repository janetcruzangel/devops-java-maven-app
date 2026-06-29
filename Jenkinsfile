#!/user/bin/env groovy
// Use this Jenkins Shared Library only in this repo
library identifier: 'devops-jenkins-shared-library@main', retriever: modernSCM(
        [$class: 'GitSCMSource',
        remote: 'https://github.com/janetcruzangel/devops-jenkins-shared-library.git',
        credentialsId: 'github-credentials'])
pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    //Define an ENV variable to hold a docker image name (dockerRepoName/imageName:tag)
    environment{
        IMAGE_NAME='janetcruzangel/demo-app:java-maven-1.0'
    }
    stages {
        
        stage("build app") {
            steps {
                script {
                    echo "buiding the application jar"
                    buildJar()

                }
            }
        }

        stage("build image") {
            steps {
                script {
                    echo "Building the docker image for the java application"
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    docker(env.IMAGE_NAME)
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    sshagent(['ec2-server-key']) {
                        // define a variable holding docker command to be executed on the EC2 server
                        def dockerCmd = "docker run -d -p 8080:8080 ${env.IMAGE_NAME}" 
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
