#!/bin/bash
docker compose up -d app

docker compose up -d nginx --command "nginx -c /etc/nginx/nginx-certbot.conf -g 'daemon off;'"

docker compose up -d certbot

docker exec keelecodes-certbot-1 certbot certonly \
  --webroot -w /var/www/html \
  -d keele.codes \
  -d www.keele.codes \
  -m mark@keele.codes \
  --agree-tos --non-interactive

docker compose stop certbot nginx app
