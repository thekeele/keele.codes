.PHONY: install local staging push prod stop clean prune

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

local:
	@echo "Starting local environment..."
	docker compose -f docker-compose.yml up -d

staging:
	@echo "Starting staging environment..."
	docker compose -f docker-compose.staging.yml up -d

push:
  @echo "Pushing latest docker image..."
  docker push thekeele/keele.codes:latest

prod:
	@echo "Starting production environment..."
	docker compose -f docker-compose.prod.yml up -d

stop:
	@echo "Stopping all services..."
	docker compose -f docker-compose.yml down
	docker compose -f docker-compose.staging.yml down
	docker compose -f docker-compose.prod.yml down

clean:
	@echo "Cleaning up services and volumes..."
	docker compose -f docker-compose.yml down -v
	docker compose -f docker-compose.staging.yml down -v
	docker compose -f docker-compose.prod.yml down -v

prune:
	@echo "Pruning docker..."
	docker system prune -a
