.PHONY: local prod build certbot stop clean install

all: local

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

build:
	@echo "Building Docker images..."
	docker compose -f docker-compose.yml build

certbot:
	@echo "Running Certbot setup script..."
	./setup-certbot.sh

local:
	@echo "Starting local environment..."
	docker compose -f docker-compose.yml up -d app nginx  # HTTP only	

prod:
	@echo "Starting production environment..."
	docker compose -f docker-compose.yml up -d

stop:
	@echo "Stopping all services..."
	docker compose down

clean:
	@echo "Cleaning up services and volumes..."
	docker compose down -v

prune:
	@echo "Pruning docker..."
	docker system prune -a
