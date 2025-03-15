.PHONY: local prod build selfsigned certbot stop clean

# Default target
all: local

# Build Docker images
build:
	@echo "Building Docker images..."
	docker-compose -f docker-compose.yml build

# Generate self-signed certificates for local development
selfsigned:
	@echo "Generating self-signed certificates..."
	mkdir -p nginx-ssl
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout nginx-ssl/selfsigned.key \
		-out nginx-ssl/selfsigned.crt \
		-subj "/CN=localhost"

# Run Certbot setup script for production certificates
certbot:
	@echo "Running Certbot setup script..."
	./setup-certbot.sh

# Start local environment with override
local: selfsigned
	@echo "Starting local environment..."
	docker-compose up -d

# Start production environment (base file only)
prod:
	@echo "Starting production environment..."
	docker-compose -f docker-compose.yml up -d

# Stop all services
stop:
	@echo "Stopping all services..."
	docker-compose down

# Stop and remove volumes (clean slate)
clean:
	@echo "Cleaning up services and volumes..."
	docker-compose down -v
