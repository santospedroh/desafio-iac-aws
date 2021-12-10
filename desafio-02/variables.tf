variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "instance_name" {
    type = string
    default = "post-it-app"
}
variable "ami" {
    type = string
    default = "ami-04902260ca3d33422"
}
variable "sg_ports" {
    type = list(number)
    description = "Lista com as portas para o ingress do sg"
    default = [80, 443, 22]
}
