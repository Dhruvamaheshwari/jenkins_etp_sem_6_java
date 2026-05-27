pipeline{
    agent any

    tools{
        jdk 'JDK-23'
        maven "Maven-3.9"
    }

    triggers{
        pollSCM "H/2 * * * *"
    }

    environment{
        DOCKER_IMAGE = "dhruvamaheshwari47/etp_jenkins_java_maven"
        DOCKER_TAG = "latest"
        CONTAINER_NAME = "etp_jenkins_java"
        PORT = "8080"
    }

    stages{
        stage("clone Repo")
        {
            steps{
                git url: "https://github.com/Dhruvamaheshwari/jenkins_etp_sem_6_java.git",
                branch: "main"
            }
        }

        stage("install all dependecy")
        {
            steps{
                bat "mvn clean compile"
                bat "mvn package"
            }
        }
        
        stage('create the docker image')
        {
            steps{
                bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('push the image on docker hub')
        {
            steps{
                withCredentials([
                    usernamePassword(
                        credentialsId:"dockerhub",
                        usernameVariable:"DOCKER_USERNAME",
                        passwordVariable:"DOCKER_PASSWORD"
                    )
                ]){
                    bat """ 
                        echo %DOCKER_PASSWORD%| docker login -u --password-stdin
                    """
                }
            }
        }

        stage('stop the old container')
        {
            steps{
                bat "docker rm -f ${CONTAINER_NAME} | ture"
            }
        }

        stage("Re run the container")
        {
            steps{
                bat "docker run -d -p ${PORT}:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }
    post{
        success{
            echo "pipeline is done"
        }
    }
}