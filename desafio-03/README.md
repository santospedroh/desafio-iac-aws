# Desafio 3 🐍

Provisionamento de 2 instância EC2 em zonas de disponibilidades diferentes com um Load Balancer direcionando as requests de forma automatizada via [Terraform](https://www.terraform.io/)

A aplicação que será utilizada é o famoso jogo da cobrinha feito em JavaScript [Snake Game](https://github.com/goncadanilo/snake-game-js) créditos ao desenvolvedor: [Danilo Gonçalves](https://github.com/goncadanilo)

As instâncias deve conter as seguintes características:

* Shape: t3.medium
* Name: snake-game-#Numero
* Security Group: Porta 80 liberada
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Game
    - Time : Gamer Development
    - Aplicacao : Snake Game
    - BU : JavaScript

Na saída do provisionamento (Output) deve obter as seguintes informações:

* DNS público do Load Balancer

![Desafio 03 ](../img/desafio-03.png?raw=true "Desafio 03")

* 1 VPC
* 1 Internet Gateway
* 2 NatGateway
* 4 Subnets (2 Públicas e 2 Privadas)
* 3 RouteTable
    - 1 RouteTable Pública (Apontando para o InternetGateway)
    - 2 RouteTable Privadas (Cada uma apontando para um NatGateway)
* 2 Instâncias EC2 (Nas subnets privadas, Security Group com porta 80 liberada)
* Elastic Load Balancer ou Application Load Balancer (Nas subnets públicas, Security group com porta 80 liberada)