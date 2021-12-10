pipeline {
    agent any
    tools {
        terraform 'terraform_v1.0.11'
    }
    stages{
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Git Checkout'){
            steps{
                sh 'git clone git@gitlab.com:santospedroh/desafio-iac-terraform.git'
            }
        }
        stage('Terraform Init'){
            steps{
                dir('desafio-iac-terraform/desafio'){
                    sh 'pwd'
                    sh 'ls -ltr'
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Apply'){
            steps{
                dir('desafio-iac-terraform/desafio'){
                    sh 'pwd'
                    sh 'ls -ltr'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
    post {
       success {
            echo 'SUCCESS'
            slackSend channel: '#ci-cd', color: '#157B22', message: 'Deu Bom!!! Build deployed successfully - `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n(<${env.BUILD_URL}|Open>)', tokenCredentialId: 'jenkins-slack'
       }
       failure {
            echo 'ERROR'
            slackSend channel: '#ci-cd', color: '#C81414', message: 'Deu ruim... Build failed  - `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n(<${env.BUILD_URL}|Open>)', tokenCredentialId: 'jenkins-slack'
       }
       always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
            slackSend channel: '#ci-cd', color: '#5B5F68', message: 'Jenkins trabalhando...Build Started: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n(<${env.BUILD_URL}|Open>)', tokenCredentialId: 'jenkins-slack'
       }
    }
}
