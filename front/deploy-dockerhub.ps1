# Script de déploiement Docker Hub pour bobapp (PowerShell)
# Usage: .\deploy-dockerhub.ps1 [version]

param(
    [string]$Version = "latest"
)

# Configuration
$DockerUsername = "efernandez42"
$ImageName = "bobapp"

Write-Host "🚀 Déploiement de bobapp sur Docker Hub..." -ForegroundColor Green
Write-Host "📦 Version: $Version" -ForegroundColor Yellow
Write-Host "👤 Username Docker Hub: $DockerUsername" -ForegroundColor Cyan

# Vérification que Docker est en cours d'exécution
try {
    $null = docker info 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker n'est pas en cours d'exécution. Veuillez démarrer Docker." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Docker n'est pas installé ou n'est pas en cours d'exécution." -ForegroundColor Red
    exit 1
}

# Vérification que l'utilisateur est connecté à Docker Hub
$dockerInfo = docker info 2>$null
if ($dockerInfo -notmatch "Username") {
    Write-Host "❌ Vous n'êtes pas connecté à Docker Hub. Veuillez exécuter 'docker login'" -ForegroundColor Red
    exit 1
}

# Construction de l'image
Write-Host "🔨 Construction de l'image Docker..." -ForegroundColor Yellow
docker build -t $ImageName`:$Version .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de la construction de l'image Docker" -ForegroundColor Red
    exit 1
}

docker tag $ImageName`:$Version $DockerUsername/$ImageName`:$Version

# Si c'est la version latest, tagger aussi comme latest
if ($Version -ne "latest") {
    docker tag $ImageName`:$Version $DockerUsername/$ImageName`:latest
}

# Push vers Docker Hub
Write-Host "📤 Envoi de l'image vers Docker Hub..." -ForegroundColor Yellow
docker push $DockerUsername/$ImageName`:$Version
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de l'envoi de l'image vers Docker Hub" -ForegroundColor Red
    exit 1
}

if ($Version -ne "latest") {
    docker push $DockerUsername/$ImageName`:latest
}

Write-Host "✅ Déploiement terminé avec succès!" -ForegroundColor Green
Write-Host "🐳 Image disponible sur: https://hub.docker.com/r/$DockerUsername/$ImageName" -ForegroundColor Cyan
Write-Host "📋 Commandes utiles:" -ForegroundColor White
Write-Host "   docker pull $DockerUsername/$ImageName`:$Version" -ForegroundColor Gray
Write-Host "   docker run -p 80:80 $DockerUsername/$ImageName`:$Version" -ForegroundColor Gray 