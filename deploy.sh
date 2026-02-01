#!/bin/bash
set -e

# Go to script directory
cd "$(dirname "$0")"

echo "Starting Deployment..."


# Generate .env if missing
if [ ! -f .env ]; then
    echo "Creating .env with default values..."
    cat > .env <<EOF
OPENCLAW_CONFIG_DIR=./config
OPENCLAW_WORKSPACE_DIR=./workspace
OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 16 2>/dev/null || echo "changeme")
OPENCLAW_IMAGE=openclaw:local
EOF
fi

# Pull latest changes
echo "Syncing with Git..."
git pull

# Build and Start Containers
echo "Building and Starting Containers..."
docker compose up -d --build --remove-orphans

echo "Deployment Successful!"
