#!/bin/bash
docker compose -f docker-compose.prod.yml up -d app

docker compose -f docker-compose.yml up -d nginx --command "nginx -c /etc/nginx/nginx-certbot.conf -g 'daemon off;'"

docker compose -f docker-compose.prod.yml up -d certbot

docker exec keelecodes-certbot-1 certbot certonly \
  --webroot -w /var/www/html \
  -d keele.codes \
  -d www.keele.codes \
  -m mark@keele.codes \
  --agree-tos --non-interactive

make stop
