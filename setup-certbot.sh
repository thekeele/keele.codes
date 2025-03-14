#!/bin/bash

# Start Nginx in the background
docker-compose up -d nginx

# Wait to ensure Nginx is fully up
sleep 5

# Run Certbot with an explicit entrypoint override to force certificate issuance
docker-compose run --rm --entrypoint "certbot" certbot certonly \
  --webroot \
  --webroot-path=/var/www/html \
  -d keele.codes \
  --email mark@keele.codes \
  --agree-tos \
  --no-eff-email \
  --force-renewal

# Stop services after certificate is obtained
docker-compose down
