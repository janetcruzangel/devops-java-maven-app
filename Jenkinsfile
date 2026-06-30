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
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    //Define a variable holding docker-compose command
                    //It requires the yaml file and the flag ---detach for detached mode
                    def dockerCompose = "docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['ec2-server-key']) {
                        // copies docker-compose.yaml into EC2 user's home directory
                        sh 'scp docker-compose.yaml ec2-user@3.137.154.143:/home/ec2-user'
                        // This scripts assumes docker login has been already executed in the EC2 instance and Firewall allows traffic to 3080
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.137.154.143 ${dockerCompose}"
                    }
                }
            }
        }
    }
}
