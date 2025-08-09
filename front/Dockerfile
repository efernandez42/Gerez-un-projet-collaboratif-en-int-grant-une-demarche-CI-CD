# Étape de build
FROM node:18-alpine AS build

# Définition du répertoire de travail
WORKDIR /usr/local/app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances
RUN npm ci --only=production=false

# Copie du code source
COPY . .

# Build de l'application
RUN npm run build:prod

# Étape de production
FROM nginx:alpine AS production

# Installation des outils de sécurité
RUN apk add --no-cache curl

# Copie de la configuration nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copie des fichiers buildés
COPY --from=build /usr/local/app/dist/bobapp /usr/share/nginx/html

# Changement des permissions pour l'utilisateur root
RUN chown -R root:root /var/cache/nginx && \
    chown -R root:root /var/log/nginx && \
    chown -R root:root /etc/nginx/conf.d && \
    chown -R root:root /usr/share/nginx/html

# Exposition du port
EXPOSE 80

# Démarrage de nginx (utilisateur root par défaut)
CMD ["nginx", "-g", "daemon off;"]