#!/bin/bash

# Vérifier si Terraform est installé
if ! [ -x "$(command -v terraform)" ]; then
  echo "Installation Terraform..."
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform
fi

# initialiser le dossier Terraform
if ! [ -f .terraform ]; then
  echo "Initialisation du terraform ..."
  cd /terraform
  terraform init
fi

# appliquer la creation
echo "Application de la création terraform ..."
terraform apply

# Vérifier si Ansible est installé
if ! [ -x "$(command -v ansible)" ]; then
  echo "Installation Ansible..."
  sudo apt install ansible
fi

# Generer les fichiers hosts
cd ../ansible
if ! [ -f hosts ]; then
  echo "Generer le fichier host"
  echo "[wordpress]" > hosts
  echo "${terraform.outputs.wp_ip} ansible_user=admin" >> hosts
  echo "[db]" >> hosts
  echo "${terraform.outputs.db_ip} ansible_user=admin" >> hosts
fi

# Installer les roles geerlingguy avec ansible galaxy
ansible-galaxy install geerlingguy.php
ansible-galaxy install geerlingguy.apache
ansible-galaxy collection install code_egg.openlitespeed_wordpress
ansible-galaxy install geerlingguy.mysql

# Appliquer les playbooks Ansible
ansible-playbook -i hosts wordpress.yml
ansible-playbook -i hosts mariadb.yml

# Vérifier le fonctionnement
IP=$(terraform.outputs.wp_ip)
if curl -s $IP | grep "WordPress" > /dev/null; then
  echo "WordPress installé avec succes !"
else
  echo "WordPress non installé !"
  exit 1
fi
