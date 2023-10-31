# m2i-tp1 : 

## Provided files
### ansible
Ce dossier regroupe les differents fichier necessaire au deployment des playbook ansible.
- 'files':
'apache.conf.j2' est la configuration principale du serveur Apache. il contient les instuctions données à la config
'wp-config.php.j2' est la configuration de la base wordpress. Il contient la configuration de MYSQL, prefix Table, secret keys ainsi que le ABSPATH.

- 'playbook':
Ce fichier contient deux playbook ( 'database.yml & 'wordpress.yml' ) ansible avec les taches necessaires pour le deployment d'un wordpress ainsi que sa base MYSQL

- 'vars':
'default.yml' contient les variables definies pour notre installation wordpress
### terraform
- 'main.tf' est le fichier de deploiement, il creera sur le compte GCP les VM, VPC, sous reseau ainsi que les regles firewall.
- 'outputs.tf' est le fichier grace auquel on va recuperer les differentes adresses IP de nos VM
- 'terraform.tfvars' contient les differentes variables à definir pour notre projet
- 'variable.tf' est la declaration de nos variables

### Script bash
'deployment.sh' est le script a lancer qui va parcourir tous nos fichiers terraform et ansible afin de mettre en place l'environement necessaire. 
Le script crée les clé SSH necessaire pour la connection ssh au vm, et aussi les fichiers host pour nos 2 playbook ansible.
## Pre-requis:
> [!NOTE]
>- Cloner le repository dans votre workspace
>- 'credentials.json' : Il faut extraire le fichier en format json depuis votre compte GCP, le renommer 'credentials.json' et le copier à la racine du projet

## Configuration du script
- remplacer les variables du fichier 'terraform.tfvars' par les informations de votre projet
- Enfin lancer le script bash 'deployment.sh' depuis votre machine.