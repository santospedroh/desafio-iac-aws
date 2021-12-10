# Desafio 2 📝

Provisionamento de 2 instância EC2 em zonas de disponibilidades diferentes de forma automatizada via [Terraform](https://www.terraform.io/)

A aplicação que será utilizada é a [Post it](https://github.com/santospedroh/post-it/tree/docker-app) onde temos a imagem docker no [DockerHub](https://hub.docker.com/repository/docker/santospedroh/post-it)

As instâncias deve conter as seguintes características:

* Shape: t2.micro
* Name: post-it-app-#Numero
* Security Group: Porta 80, 433 e 22 liberadas utilizando dynamic blocks
* Tags: Deve conter tags locais, sendo elas:
    - Ambiente : Sandbox
    - Time : Mackenzie
    - Aplicacao : Post-it
    - BU : Python

Na saída do provisionamento (Output) deve obter as seguintes informações:

* ARN das instâncias
* IP público das instâncias
* DNS público das instâncias

![Desafio 02 ](img/desafio-02.png?raw=true "Desafio 02")

* 1 VPC
* 1 Internet Gateway
* 2 Subnet pública
* 1 RouteTable (Pública, apontando para o Internet Gateway)
* 2 Instâncias EC2 (Uma em cada subnet)