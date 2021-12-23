# Desafio IAC Terraform 📌

Exercício da disciplina IaC Terraform do curso DevOps Engineering and Cloud Solutions da Mackenzie.

* Você pode subir tudo em uma única estrutura; (vários .tf)
* Você pode utilizar módulos para organizar a estrutura;
* Você pode utilizar tudo hardcoded ou com variáveis; 

[Documentação Terraform Providers e Modules](https://registry.terraform.io/)

[Desafios](img/desafios.pdf)

## Desafio 1 👨🏽‍💻

[Detalhes do desafio 1](desafio-01)

* 1 VPC
* 1 Internet Gateway
* 1 Subnet pública
* 1 RouteTable (Pública, apontando para o Internet Gateway)
* 1 instância EC2 na subnet pública

## Desafio 2 📝

[Detalhes do desafio 2](desafio-02)

* 1 VPC
* 1 Internet Gateway
* 2 Subnet pública
* 1 RouteTable (Pública, apontando para o Internet Gateway)
* 2 Instâncias EC2 (Uma em cada subnet)

## Desafio 3 🐍

[Detalhes do desafio 3](desafio-03)

* 1 VPC
* 1 Internet Gateway
* 2 NatGateway
* 4 Subnets (2 Públicas e 2 Privadas)
* 3 RouteTable
    - 1 RouteTable Pública (Apontando para o InternetGateway)
    - 2 RouteTable Privadas (Cada uma apontando para um NatGateway)
* 2 Instâncias EC2 (Nas subnets privadas, Security Group com porta 80 liberada)
* Elastic Load Balancer ou Application Load Balancer (Nas subnets públicas, Security group com porta 80 liberada)

## Desafio 4 🐦

[Detalhes do desafio 4](desafio-04)

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

## Desafio 5 🚀

[Detalhes do desafio 5](desafio-05)

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

---

Made with ♥ by Pedro Santos :wave: [Get in touch!](https://www.linkedin.com/in/santospedroh/)
