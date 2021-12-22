pipeline {
    agent any
    tools {
        terraform "terraform_v1.0.11"
    }
    stages{
        stage("Clean Workspace") {
            steps {
                slackSend channel: "#ci-cd", color: "#5B5F68", message: ":warning: Jenkins trabalhando...Build Started ${desafio} -  `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n(<${env.BUILD_URL}|Open>)", tokenCredentialId: "jenkins-slack"
                echo "Limpando Workspace"
                echo "O ${desafio} será executado..."
                cleanWs() /* clean up our workspace */
            }
        }
        stage("Git Checkout"){
            steps{
                echo "Clone do repositório Terraform"
                sh "git clone git@github.com:santospedroh/desafio-iac-aws.git"
            }
        }
        stage("Terraform Init"){
            steps{
                dir("desafio-iac-aws/${desafio}"){
                    echo "Iniciando módulos e providers"
                    sh "pwd"
                    sh "ls -ltr"
                    sh "terraform init"
                }
            }
        }
        stage("Terraform Plan"){
            steps{
                dir("desafio-iac-aws/${desafio}"){
                    echo "Executando plano de provisionamento"
                    sh "terraform plan | tee -a terraform_plan.txt"
                    slackUploadFile channel: "#ci-cd", filePath: "terraform_plan.txt", initialComment: ":page_facing_up: Plano de execução do terraform - ${desafio} - `${env.JOB_NAME}` #${env.BUILD_NUMBER}"
                }
            }
        }
        stage("Terraform Apply"){
            steps{
                dir("desafio-iac-aws/${desafio}"){
                    echo "Provisionando a infra-estrutura"
                    sh "pwd"
                    sh "ls -ltr"
                    sh "terraform apply -auto-approve"
                }
            }
        }
    }
    post {
       success {
            echo "SUCCESS"
            slackSend channel: "#ci-cd", color: "#157B22", message: ":white_check_mark: Deu Bom!!! Build Deployed Successfully ${desafio} - `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n(<${env.BUILD_URL}|Open>)", tokenCredentialId: "jenkins-slack"
       }
       failure {
            echo "ERROR"
            slackSend channel: "#ci-cd", color: "#C81414", message: ":red_circle: Deu ruim... Build Failed ${desafio} - `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n(<${env.BUILD_URL}|Open>)", tokenCredentialId: "jenkins-slack"
       }
       always {
            echo "One way or another, I have finished"
            deleteDir() /* clean up our workspace */
       }
    }
}