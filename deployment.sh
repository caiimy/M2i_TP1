#!/bin/bash
echo "Je suis la !!!!!!"
# creer la clé ssh
if [ -f ~/.ssh/id_rsa ]; then
  rm ~/.ssh/id_rsa
  rm ~/.ssh/id_rsa.pub
  echo "clé supprimée"
fi
echo "Création de la nouvelle clé"
ssh-keygen -t rsa -f ~/.ssh/id_rsa


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
  cd ./terraform/
  terraform init
fi

# appliquer la creation
echo "Application de la création terraform ..."
terraform apply -auto-approve

# Variable IP wordpress
IP_WP=$(terraform output wp_extern_ip)
IP_DB=$(terraform output db_extern_ip)
IP_WP_EXT=$(terraform output wp_ip)

# Vérifier si Ansible est installé
if ! [ -x "$(command -v ansible)" ]; then
  echo "Installation Ansible..."
  sudo apt update && sudo apt install ansible
else
  echo "Ansible deja present"
fi

# Generer les fichiers hosts
if ! [ -d inventories ];then
  mkdir ../ansible/inventories/
fi

cd ../ansible/inventories
if ! [ -f hosts ]; then
  echo "Generer le fichier host"

  echo "[wordpress]" >> hosts
  echo $IP_WP ansible_user=m2i-tp1 ansible_connection=ssh ansible_private_key_file=~/.ssh/id_rsa >> hosts
  echo "[db]" >> hosts
  echo $IP_DB ansible_user=m2i-tp1 ansible_connection=ssh ansible_private_key_file=~/.ssh/id_rsa >> hosts
fi
cd ..

# Installer les roles geerlingguy avec ansible galaxy
# ansible-galaxy install geerlingguy.php
# ansible-galaxy install geerlingguy.apache
# ansible-galaxy install geerlingguy.mysql

# Appliquer les playbooks Ansible
ansible-playbook -i inventories/hosts playbook/database.yml
ansible-playbook -i inventories/hosts playbook/wordpress.yml

# Vérifier le fonctionnement
if curl -s "$IP_WP_EXT" | grep "WordPress" > /dev/null; then
  echo "WordPress installé avec succes !"
else
  echo "WordPress non installé !"
  exit 1
fi
