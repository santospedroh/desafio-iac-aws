# Desafio 4 🐦

Provisionamento de 2 instância EC2 em zonas de disponibilidades diferentes com um Load Balancer direcionando as requests e um Auto Scaling Group para termos alta disponibilidade de forma automatizada via [Terraform](https://www.terraform.io/)

A aplicação que será utilizada será o game [Flappy Bird](https://github.com/Rod1Andrade/Flappy-Bird-JS) créditos ao desenvolvedor: [Rodrigo Andrade](https://github.com/Rod1Andrade)

As instâncias deve conter as seguintes características:

* Shape: t3.medium
* Name: flappy-bird-game-#Numero
* Security Group: Porta 80 liberada
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Game
    - Time : Gamer Development
    - Aplicacao : Flappy Bird
    - BU : JavaScript

Na saída do provisionamento (Output) deve obter as seguintes informações:

* DNS público do Load Balancer

![Desafio 04 ](img/desafio-04.png?raw=true "Desafio 04")

* 1 VPC
* 1 Internet Gateway
* 2 NatGateway
* 4 Subnets (2 Públicas e 2 Privadas)
* 3 RouteTable
    - 1 RouteTable Pública (Apontando para o InternetGateway)
    - 2 RouteTable Privadas (Cada uma apontando para um NatGateway)
* 1 AutoScaling (Nas subnets privadas)
* 2 Instâncias EC2 (Nas subnets privadas, Security Group com porta 80 liberada)
* Elastic Load Balancer ou Application Load Balancer (Nas subnets públicas, Security group com porta 80 liberada)