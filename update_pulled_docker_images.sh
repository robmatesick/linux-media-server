#!/bin/bash
echo "Pulling latest version of all cached Docker images..."
docker images --format "{{.Repository}}:{{.Tag}}" | grep ':latest' | xargs -L1 docker pull;

echo ""
echo "Removing outdated images..."
docker image rm $(docker images --filter dangling=true -q)
