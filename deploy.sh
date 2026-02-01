#!/bin/bash
set -e

# Go to script directory
cd "$(dirname "$0")"

echo "Starting Deployment..."

# Pull latest changes
echo "Syncing with Git..."
git pull

# Build and Start Containers
echo "Building and Starting Containers..."
docker compose up -d --build --remove-orphans

echo "Deployment Successful!"
