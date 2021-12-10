# Desafio 5 🚀

Provisionamento de toda infraestrutura para executar uma aplicação em nodejs com alta disponibilidade de forma automatizada via [Terraform](https://www.terraform.io/)

A aplicação deve 1 load balancer distribuindo as requisições para 3 instâncias e o banco de dados onde a aplicação será conectanda deve ser um RDS MySQL.

A aplicação que será utilizada é a [Ecoleta](https://github.com/santospedroh/nlw-ecoleta) onde temos a imagem docker no [DockerHub](https://hub.docker.com/repository/docker/santospedroh/ecoleta)

As 3 instâncias da aplicação devem conter as seguintes características:

* Shape: t2.micro
* Name: ecoleta-app-#Numero 
* Security Group: Porta 80, 433 e 22 liberadas utilizando dynamic blocks
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Production
    - Time : Engenharia
    - Aplicacao : Ecoleta
    - BU : Sustentabilidade

A arquitetura VPC deve ficar de seguinte forma:

![Desafio 05 ](img/desafio-05.png?raw=true "Desafio 05")

* 1 VPC
* 1 Internet Gateway
* 2 NatGateway
* 4 Subnets (2 Públicas e 2 Privadas)
* 3 RouteTable
    - 1 RouteTable Pública (Apontando para o InternetGateway)
    - 2 RouteTable Privadas (Cada uma apontando para um NatGateway)
* 1 AutoScaling (Nas subnets privadas)
* 2 Instâncias EC2 (Nas subnets privadas, Security Group com porta 80 liberada)
* 1 RDS MySQL (Subnet privada, Security Group com porta 3306 liberada)
* Elastic Load Balancer ou Application Load Balancer (Nas subnets públicas, Security group com porta 80 liberada)