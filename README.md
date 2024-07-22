# Infrastructure DORA Metrics

## Description
Infrastructure complète pour calculer et visualiser les métriques DORA basées sur les processus de déploiement d'une application .NET (une todolist).

## Prérequis
- Terraform v1.7.3
- Compte AWS avec les droits appropriés : Il faut pouvoir créer tout type de ressources, notamment des IAM roles
- Authentification AWS (SSO recommandé)
```bash
aws sso configure
```
Configurer avec le SSO de Onepoint sur AWS puis pour s'authentifier :
```bash
aws sso login
```

## Déploiement
- Cloner le projet GitHub : 
```bash
git clone https://github.com/thibs12/infrastructure.git
cd infrastructure
```
- Créer un secret dans **AWS Secrets Manager** dans la console pour les credentials Docker (username, password sachant que le password est un token ici, à générer dans docker hub) pour la registry Docker qui contiendra l'image à déployer.
Ensuite, référencer l'ARN du secret dans le fichier *terraform.tfvars* pour la variable *docker_secrets_arn*
- A noter que les credentials de cette registry doivent aussi être référencés dans le workflow *CI.yml* du repository 'todolist' dans le job *Docker* pour l'authentification.
- Pour créer une registry, il faut un compte Docker Hub, créer un repository ainsi qu'un token, et les référencer comme expliqué ci-dessus.

Il y a deux dossiers, **app** et **dora** pour deux parties de l'infrastructure : 
- **app** : C'est l'infrastructure pour tout ce qui concerne l'application à déployer (ECS Fargate, Auto Scaling Group, Load Balancer, ...), avec ce qui sert de base pour les deux parties également (VPC, Subnets).
- **dora** : C'est l'infrastructure correspondant à la solution pour calculer et visualiser automatiquement les métriques DORA. (RDS, Lambda). Cette partie **<span style="color:red">dépend de l'infrastructure de l'application.</span>**

Pour chacun de ces dossiers, et **en commençant par la partie app** : 

- Initialiser Terraform
```bash
terraform init
```

- Générer un plan pour vérifier la configuration
```bash
terraform plan
```

- Déployer l'infrastructure
```bash
terraform apply -auto-approve
```

## Métriques DORA

