#!/bin/bash
init:
	source var.sh && terraform init

plan:
	source var.sh && terraform validate && terraform plan

apply:
	source var.sh && terraform apply
	source var.sh && terraform output inventory > ../ansible/hosts.ini

destroy:
	source var.sh && terraform destroy
