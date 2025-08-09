# Script de test Docker pour bobapp
Write-Host "🧪 Test Docker local pour bobapp" -ForegroundColor Green

# 1. Vérifier Docker
Write-Host "1️⃣ Vérification de Docker..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info 2>$null
    if ($dockerInfo -match "Username") {
        Write-Host "✅ Docker est en cours d'exécution et connecté" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Docker fonctionne mais non connecté à Docker Hub" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Docker n'est pas accessible" -ForegroundColor Red
    exit 1
}

# 2. Construire l'image
Write-Host "2️⃣ Construction de l'image..." -ForegroundColor Yellow
docker build -t bobapp .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Image construite avec succès" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de la construction" -ForegroundColor Red
    exit 1
}

# 3. Lister les images
Write-Host "3️⃣ Images disponibles:" -ForegroundColor Yellow
docker images | findstr bobapp

# 4. Démarrer le conteneur
Write-Host "4️⃣ Démarrage du conteneur..." -ForegroundColor Yellow
docker run -d --name test-bobapp -p 8080:80 bobapp
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Conteneur démarré sur http://localhost:8080" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors du démarrage du conteneur" -ForegroundColor Red
    exit 1
}

# 5. Attendre et vérifier
Write-Host "5️⃣ Attente du démarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 6. Vérifier le statut
$containerStatus = docker ps | findstr test-bobapp
if ($containerStatus) {
    Write-Host "✅ Conteneur en cours d'exécution" -ForegroundColor Green
    Write-Host "🌐 Ouvrez http://localhost:8080 dans votre navigateur" -ForegroundColor Cyan
} else {
    Write-Host "❌ Conteneur non trouvé" -ForegroundColor Red
}

Write-Host "`n📋 Commandes utiles:" -ForegroundColor White
Write-Host "   Voir les logs: docker logs test-bobapp" -ForegroundColor Gray
Write-Host "   Arrêter: docker stop test-bobapp" -ForegroundColor Gray
Write-Host "   Supprimer: docker rm test-bobapp" -ForegroundColor Gray
