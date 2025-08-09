# 🐳 Déploiement Docker Hub - bobapp

Ce document explique comment déployer l'application bobapp sur Docker Hub.

## 📋 Prérequis

- Docker installé et en cours d'exécution
- Compte Docker Hub créé
- Accès en ligne de commande (PowerShell sur Windows, Bash sur Linux/Mac)

## 🔧 Configuration

### 1. Connexion à Docker Hub

```bash
docker login
```

Entrez vos identifiants Docker Hub quand demandé.

### 2. Configuration du nom d'utilisateur

Éditez le fichier `deploy-dockerhub.ps1` (Windows) et remplacez :

```bash
DOCKER_USERNAME="your-dockerhub-username"
```

par votre nom d'utilisateur Docker Hub réel.

## 🚀 Déploiement

### Option 1 : Script automatique (Recommandé)

#### Sur Windows (PowerShell) :
```powershell
.\deploy-dockerhub.ps1
```

### Option 2 : Commandes manuelles

```bash
# 1. Construction de l'image
docker build -t bobapp .

# 2. Tag de l'image avec votre nom d'utilisateur
docker tag bobapp your-username/bobapp:latest

# 3. Push vers Docker Hub
docker push your-username/bobapp:latest
```

### Option 3 : Scripts npm

```bash
# Construction de l'image
npm run docker:build

# Déploiement automatique
npm run docker:push
```

## 🏷️ Gestion des versions

### Déployer une version spécifique :
```bash
# Bash
./deploy-dockerhub.sh "v1.0.0"
```

### Tags automatiques :
- L'image est automatiquement taggée avec la version spécifiée
- Si ce n'est pas "latest", elle est aussi taggée comme "latest"

## 🔍 Vérification

### Vérifier que l'image est disponible :
```bash
docker pull your-username/bobapp:latest
```

### Tester l'image localement :
```bash
docker run -p 80:80 your-username/bobapp:latest
```

### Vérifier sur Docker Hub :
Visitez : `https://hub.docker.com/r/your-username/bobapp`

## 📁 Structure des fichiers

```
├── Dockerfile                 # Configuration Docker optimisée
├── .dockerignore             # Fichiers exclus de l'image
├── deploy-dockerhub.ps1      # Script de déploiement (Windows)
├── DOCKER_DEPLOYMENT.md      # Cette documentation
└── nginx.conf                # Configuration Nginx
```

## ❗ Dépannage

### Erreur "Docker n'est pas en cours d'exécution"
- Démarrez Docker Desktop
- Vérifiez que le service Docker est actif

### Erreur "Non connecté à Docker Hub"
```bash
docker login
```

### Erreur de construction
- Vérifiez que tous les fichiers sont présents
- Vérifiez la syntaxe du Dockerfile
- Vérifiez les logs de construction
