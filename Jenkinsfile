#!/user/bin/env groovy
//@Library('jenkins-shared-library') //the name of shared library configured in Jenkins
def gv
pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    echo "Building the application..."

                }
            }
        }

        stage("build image") {
            steps {
                script {
                   echo "Building the image..."
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }
}
