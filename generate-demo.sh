#!/bin/bash
set -e

echo "🎬 LTS Demo Generator"
echo "===================="
echo ""

# Detect docker-compose or docker compose
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    echo "❌ Docker Compose not found. Please install Docker Compose."
    exit 1
fi

echo "Using: $DOCKER_COMPOSE"
echo ""

# Create output directory
mkdir -p demo-output

echo "📦 Building Docker images..."
$DOCKER_COMPOSE -f docker-compose.demo.yml build

echo ""
echo "🚀 Starting Ollama and pulling llama3.2 model (this may take a few minutes)..."
$DOCKER_COMPOSE -f docker-compose.demo.yml up ollama-setup

echo ""
echo "🎥 Generating demo video with VHS..."
$DOCKER_COMPOSE -f docker-compose.demo.yml up demo

echo ""
echo "🧹 Cleaning up..."
$DOCKER_COMPOSE -f docker-compose.demo.yml down

if [ -f "demo-output/demo.gif" ]; then
    echo ""
    echo "✅ Demo generated successfully!"
    echo "📁 Output: demo-output/demo.gif"

    # Copy to root directory if desired
    if [ "$1" = "--copy" ]; then
        cp demo-output/demo.gif demo.gif
        echo "📋 Copied to demo.gif"
    fi
else
    echo ""
    echo "❌ Demo generation failed. Check the logs above."
    exit 1
fi
