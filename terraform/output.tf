locals {
    inventory = <<EOF
mongo ansible_host=${aws_instance.mongo.private_ip}
bastion ansible_host=${aws_eip.bastion.public_ip}

[frontend]
${join("\n",data.aws_instances.frontend.private_ips)}

[backend]
${join("\n",data.aws_instances.backend.private_ips)}

[gated]
frontend

[gated:children]
frontend
backend

[all:vars]
ansible_ssh_private_key_file="${var.ssh_private_key}"
ansible_user=ubuntu

[gated:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i ${var.ssh_private_key} ubuntu@${aws_eip.bastion.public_ip}"'
frontend_loadbalancer_address=${aws_lb.frontend.dns_name}
backend_loadbalancer_address=${aws_lb.backend.dns_name}
mongo_loadbalancer_address=${aws_lb.mongo.dns_name}
EOF
}

output "inventory" {
    value = "${local.inventory}"
}