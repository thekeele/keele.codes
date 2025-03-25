.PHONY: local prod build selfsigned certbot stop clean

# Default target
all: local

# Install Docker and Docker Compose on Ubuntu 22.04
install:
	@echo "Installing Docker and Docker Compose on Ubuntu 22.04..."
	sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --yes
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo usermod -aG docker $${USER}
	sudo apt install -y docker-compose-plugin
	@echo "Docker and Docker Compose installed. Log out and back in to use docker without sudo, or run 'newgrp docker'."

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
