def gv
pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    stages {
            stage("increment version") {
                steps {
                    script {
                       echo 'incrementing application version...'
                       //Tell maven to build  a new version and update pox.xml
                       sh 'mvn build-helper:parse-version versions:set \
                       -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                       versions:commit'
                       //To read the new version generated, will get it from pom.xml and save it in a variable
                       // The variable is an array of all version matching the regular expression
                       def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                       //As we have just one version tag, we get element 0 and then the first element, which represents 0.0.0
                       def version = matcher[0][1]
                       //$BUILD-NUMBER is a Jenkins env variable in the current pipeline job
                       //env.IMAGE_NAME is another jenkins env variable
                       env.IMAGE_NAME = "${version}-${env.BUILD-NUMBER}"
                    }
                }
            }
        stage("build app") {
            steps {
                script {
                   echo 'building the application...'
                   //Cleans the target folder before generating a new version so we can have only one single jar
                   sh 'mvn clean package'
                }
            }
        }
        stage("build image") {
            steps {
                script {
                    echo 'building the docker image...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                            echo Logging in to Docker Hub with username: $DOCKER_USERNAME"
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                            docker build -t janetcruzangel/demo-app:${IMAGE_NAME} .
                            docker push janetcruzangel/demo-app:${IMAGE_NAME}
                        '''
                    }
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
