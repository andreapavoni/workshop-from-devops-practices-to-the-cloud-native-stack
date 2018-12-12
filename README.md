# Power App Demo on AWS with 

# Usage:
- `cd terraform`
- make sure a file called `var.sh` is present here with AWS credentials 
- `make init` initializes terraform
- `make plan` checks whether is save to apply the terraform configuration to your cloud infrastructure
- `make apply` applies your terraform configurations to your cloud infrastructure and generates ansible inventory to be used later
- `cd ../ansible`
- `make prepare` installs python on all machines
- `make run` configures all your machines with applications and code
- check out the value for `frontend_loadbalancer_address` variable that is found [here](ansible/hosts.ini)

# Teardown
- `cd terraform`
- comment all content found in `output.tf`
- `make destroy`

# Exercise #1 (Terraform)
- Using terraform create 3 virtual machine on your favorite Cloud Provider using an AutoscalingGroup in a newly created VPC (all the machines can have a Public IP) 
- After this is done, please configure a ApplicationLoadBalancer (loadbalancer as service) to expose port 80 and redirest traffic to all machines at port 8080
- Using `output`, provided by Terraform, generate an Ansible Inventory

# Exercice #2 (Ansible)
- Create a simple playbook called `prepare.yml` to install python on all machines
- Create an Ansible role to run on all machines
- Populate the role to:
    - install apache2
    - install php7.0
    - configure the Virtual Host of Apache to expose on port 8080
    - create a basic `index.php` to visualize the private IP of the node

# Expected output
Visiting the loadbalancer url we should see a webpage generated with our `index.php` and refreshing the page should give us a different page body based on which node the loadbalancer redirects the request