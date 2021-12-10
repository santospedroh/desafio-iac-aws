# Desafio 1 👨🏽‍💻

Provisionamento de uma instância EC2 de forma automatizada via [Terraform](https://www.terraform.io/)

A instância deve conter as seguintes características:

* Shape: t3.medium
* Name: ec2-iac-site
* Security Group: Porta 80, 433 e 22 liberadas utilizando dynamic blocks
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Development
    - Time : Mackenzie
    - Aplicacao : Site
    - BU : Conta Digital

Na saída do provisionamento (Output) deve obter as seguintes informações:

* ARN da instância
* IP público da instância
* DNS público da instância

A arquitetura VPC deve ficar de seguinte forma:

![Desafio 01 ](../img/desafio-01.png?raw=true "Desafio 01")

* 1 VPC
* 1 Internet Gateway
* 1 Subnet pública
* 1 RouteTable (Pública, apontando para o Internet Gateway)
* 1 instância EC2 na subnet pública