pipeline {
    agent any

    tools {
        jdk 'JDK-27'
        maven 'Maven-3.9.16'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling Java application...'
                bat 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                bat 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Creating WAR file...'
                bat 'mvn package -DskipTests'
            }
        }

        stage('Archive') {
            steps {
                echo 'Archiving WAR artifact...'

                archiveArtifacts artifacts: 'target/student-feedback-portal.war',
                                 fingerprint: true
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying WAR to Tomcat...'

                bat '''
                    copy /Y "target\\student-feedback-portal.war" "D:\\apache-tomcat-9.0.122\\webapps\\student-feedback-portal.war"
                '''

                echo 'WAR copied to Tomcat webapps directory.'
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}
