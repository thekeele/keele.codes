#!/bin/bash
# Switch to SSL config
cp nginx-ssl.conf nginx.conf

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
