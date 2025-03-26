#!/bin/bash
# Switch to certbot nginx config
cp nginx-certbot.conf nginx.conf

# Start app and nginx on port 80
docker compose up -d app nginx

# Get certs
docker compose up -d certbot

docker exec keelecodes-certbot-1 certbot certonly \
  --webroot -w /var/www/html \
  -d keele.codes \
  -d www.keele.codes \
  -m mark@keele.codes \
  --agree-tos --non-interactive

# Switch to SSL nginx config
cp nginx-ssl.conf nginx.conf

# Restart nginx
docker compose up -d nginx
