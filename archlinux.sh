#!/bin/bash
## Archlinux environment setup for my-read-me project

# Environment vars

# Set default values for DB_USER and DB_PASSWORD
DB_USER="default_user"
DB_PASSWORD="default_password"

# Check if Docker is running in rootless mode
if docker ps &> /dev/null; then
    DOCKER_CMD="docker"
else
    if sudo docker ps &> /dev/null; then
        DOCKER_CMD="sudo docker"
    else
        echo "Docker is not accessible. Please ensure Docker is properly installed."
        exit 1
    fi
fi

# Setup
git clone https://github.com/enrell/my-read-me.git
cd my-read-me
cp .env.local-example .env

# Prompt for PostgreSQL credentials
echo "Please provide PostgreSQL username: "
read -r provided_user
if [ -n "$provided_user" ]; then
    DB_USER="$provided_user"
fi

echo "Please provide PostgreSQL password: "
read -r provided_password
if [ -n "$provided_password" ]; then
    DB_PASSWORD="$provided_password"
fi

# Create a Docker network if it doesn't exist
if ! $DOCKER_CMD network inspect my-read-me-network &> /dev/null; then
    $DOCKER_CMD network create my-read-me-network
fi

# Build and start Docker containers
$DOCKER_CMD compose build
yarn install
$DOCKER_CMD compose up -d

echo "Access localhost:3000 in your browser"

