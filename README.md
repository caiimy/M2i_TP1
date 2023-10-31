# m2i-tp1 : 
# Créer des VM sur GCP à l’aide de terraform et déployer une application Wordpress dans ces VM avec Ansible

## Provided files
### ansible
Ce dossier regroupe les differents fichier necessaire au deployment des playbook ansible.
#### le dossier files
### playbook
Ce fichier contient les fichiers ansible pour le deployment de la base donnée MYSQL ainsi que wordpress
### vars
### terraform

## Pre-requis:
> [!NOTE]
>- Cloner le repository dans votre workspace
>- credentials.json : Il faut extraire le fichier en format json depuis votre compte GCP, le renommer credentials.json et le copier à la racine du projet
- remplacer les variables du fichier terraform.tfvars par les informations de votre projet
- Enfin lancer le script bash deployment.sh depuis votre machine