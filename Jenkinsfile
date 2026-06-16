#!/user/bin/env groovy
//the name of a global shared library configured in Jenkins
//@Library('jenkins-shared-library@main') 
//@Library('jenkins-shared-library@2.0') 

//when we want to reference a jenkisn shared lib from Git
library identifier: 'devops-jenkins-shared-library@main', retriever: modernSCM(
        [$class: 'GitSCMSource',
        remote: 'https://github.com/janetcruzangel/devops-jenkins-shared-library.git',
        credentialsId: 'github-credentials'])
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
                    buildJar()

                }
            }
        }

        stage("build image") {
            steps {
                script {
                    buildImage 'janetcruzangel/demo-app:jma-3.0'
					dockerLogin()
					dockerPush 'janetcruzangel/demo-app:jma-3.0'
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
