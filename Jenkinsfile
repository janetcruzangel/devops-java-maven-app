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
   /* 
   environment{
        IMAGE_NAME='janetcruzangel/demo-app:java-maven-1.0'
    }
    */
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "${version}-${env.BUILD_NUMBER}"
                }
            }
        }        
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
                    // Define a variable holding docker-compose command
                    // It requires the yaml file and the flag ---detach for detached mode
                    // def dockerCompose = "docker-compose -f docker-compose.yaml up --detach"
                    // Variable that holds script shell file to execute by docker-compose
                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    def ec2Instance = "ec2-user@3.137.154.143"
                    sshagent(['ec2-server-key']) {
                        // copies shell script into EC2 user's home directory
                        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        // copies docker-compose.yaml into EC2 user's home directory
                        sh "scp docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        // This scripts assumes docker login has been already executed in the EC2 instance and Firewall allows traffic to 3080
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
        stage("commit version update") {
            steps {
                script {
                    echo 'committing version update'
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        //to avoid Git complains when commiting, this has to be setup just the first time
                        //--global is for all repos and the lack of it applies config just to this repo
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'
                        
                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'
                        //connect to GIT repo from local repo to the remote one
                        sh "git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/janetcruzangel/devops-java-maven-app.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        //csend changes to remote
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}
