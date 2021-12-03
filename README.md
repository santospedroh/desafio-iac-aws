# Desafio IAC Terraform 📌

Exercício da disciplina IaC Terraform do curso DevOps Engineering and Cloud Solutions da Mackenzie.

## Desafio 👨🏽‍💻

Provisionamento de uma instância EC2 de forma automatizada via [Terraform](https://www.terraform.io/)

A instância deve conter as seguintes características:

* Shape: t3.medium
* Name: Ec2-iac
* Security Group: Porta 80, 433 e 22 liberadas utilizando dynamic blocks
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Dev
    - Time : Mackenzie
    - Aplicacao : Frontend
    - BU : Conta Digital

Na saída do provisionamento (Output) deve obter as seguintes informações:

* ARN da instância
* IP público da instância
* DNS público da instância

A arquitetura VPC deve ficar de seguinte forma:

![Arquitetura VPC ](img/arquitetura_vpc.png?raw=true "VPC")

* 1 VPC
* 1 Internet Gateway
* 1 Subnet pública
* 1 RouteTable (Pública, apontando para o Internet Gateway)
* 1 EC2 na subnet pública

## Desafio Plus Application 🚀

Provisionamento de toda infraestrutura para executar uma aplicação em nodejs com alta disponibilidade de forma automatizada via [Terraform](https://www.terraform.io/)

A aplicação deve 1 load balancer distribuindo as requisições para 3 instâncias e o banco de dados onde a aplicação será conectanda deve ser um RDS MySQL.

A aplicação que será utilizada é a [Ecoleta](https://github.com/santospedroh/nlw-ecoleta) onde temos a imagem docker no [DockerHub](https://hub.docker.com/repository/docker/santospedroh/ecoleta)

As 3 instâncias da aplicação devem conter as seguintes características:

* Shape: t2.micro
* Name: ECOLETA-APP-#Numero 
* Security Group: Porta 80, 433 e 22 liberadas utilizando dynamic blocks
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Prod
    - Time : Engenharia
    - Aplicacao : Backend
    - BU : Sustentabilidade

A arquitetura VPC deve ficar de seguinte forma:

![Desafio Plus VPC ](img/aws_ecoleta.drawio.png?raw=true "Plus VPC")

* 1 VPC
* 1 Internet Gateway
* 1 Subnet pública
* 1 RouteTable (Pública, apontando para o Internet Gateway)
* 1 Subnet privada
* 1 RDS MySQL na subnet privada
* 3 EC2 na subnet pública

---

Made with ♥ by Pedro Santos :wave: [Get in touch!](https://www.linkedin.com/in/santospedroh/)
