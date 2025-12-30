##
Deletar todos os resources do namespace antes de rodar o terraform destroy.
O backup é criado no mesmo namespace que a VM está rodando. Caso exista um backup no namespace usado pelo terraform script, o terraform destroy vai falhar.