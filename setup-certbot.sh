#!/bin/bash
# Start app and nginx on port 80
docker compose up -d app nginx

# Get certs
docker compose up -d certbot
docker exec keelecodes-certbot-1 certbot certonly \
  --webroot -w /var/www/html \
  -d keele.codes \
  -m your-email@example.com \
  --agree-tos --non-interactive

# Stop nginx to swap configs
docker compose stop nginx

# Switch to SSL config
cp nginx-ssl.conf nginx.conf

# Restart with SSL
docker compose up -d nginx
