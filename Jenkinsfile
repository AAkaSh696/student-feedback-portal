
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
    }

    post {
        success {
            echo 'CI Pipeline completed successfully!'
        }

        failure {
            echo 'CI Pipeline failed. Check the console output.'
        }
    }
}
