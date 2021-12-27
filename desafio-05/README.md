# Desafio 5 🚀

Provisionamento de toda infraestrutura para executar uma aplicação em nodejs com alta disponibilidade de forma automatizada via [Terraform](https://www.terraform.io/)

A aplicação deve 1 load balancer distribuindo as requisições para 3 instâncias e o banco de dados onde a aplicação será conectanda deve ser um RDS MySQL.

A aplicação que será utilizada é a [Ecoleta](https://github.com/santospedroh/nlw-ecoleta) onde temos a imagem docker no [DockerHub](https://hub.docker.com/repository/docker/santospedroh/ecoleta)

As 3 instâncias da aplicação devem conter as seguintes características:

As instâncias deve conter as seguintes características:

* Shape: t2.micro
* Name: ecoleta-app-asg 
* Security Group: Porta 80
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Production
    - Time : Engenharia
    - Aplicacao : Ecoleta
    - BU : Sustentabilidade

A arquitetura VPC deve ficar de seguinte forma:

![Desafio 05 ](../img/desafio-05.png?raw=true "Desafio 05")

* 1 VPC
* 1 Internet Gateway
* 3 NatGateway
* 6 Subnets (3 Públicas e 3 Privadas)
* 4 RouteTable
    - 1 RouteTable Pública (Apontando para o InternetGateway)
    - 3 RouteTable Privadas (Cada uma apontando para um NatGateway)
* 1 AutoScaling (Nas subnets privadas)
* 1 Instância EC2 Jump (Na subnet pública, Security Group com porta 22 liberada)
* 2 Instâncias EC2 (Nas subnets app privadas, Security Group com porta 80 liberada)
* 1 RDS MySQL (Na Subnet db privada, Security Group com porta 3306 liberada)
* 1 Application Load Balancer (Nas subnets públicas, Security group com porta 80 liberada)