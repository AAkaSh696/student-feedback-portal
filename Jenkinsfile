
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
                echo 'Running JUnit tests...'
                bat 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Generating WAR file...'
                bat 'mvn package -DskipTests'
            }
        }

        stage('Archive') {
            steps {
                echo 'Archiving WAR artifact...'

                archiveArtifacts(
                    artifacts: 'target/student-feedback-portal.war',
                    fingerprint: true
                )
            }
        }

        stage('Deploy and Health Check') {
            steps {
                echo 'Deploying application to Tomcat...'

                bat '''
                    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "scripts\\deploy-and-verify.ps1"
                '''
            }
        }
    }

    post {
        always {
            junit(
                testResults: 'target/surefire-reports/*.xml',
                allowEmptyResults: true
            )
        }

        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed. Check the console output.'
        }
    }
}
