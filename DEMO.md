# Demo Generation

This directory contains a Docker Compose setup to generate the demo GIF for LTS using a real working environment with Ollama.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

Run the automated demo generation script:

```bash
./generate-demo.sh
```

The script will:
1. Build the Docker image with LTS and VHS
2. Start Ollama and pull the llama3.2 model
3. Generate the demo GIF using VHS with actual LTS commands
4. Save the output to `demo-output/demo.gif`

To also copy the generated demo to the root directory:

```bash
./generate-demo.sh --copy
```

## Manual Setup

If you prefer to run the steps manually:

### 1. Build the images

```bash
docker-compose -f docker-compose.demo.yml build
```

### 2. Start Ollama and pull the model

```bash
docker-compose -f docker-compose.demo.yml up ollama-setup
```

This will download the llama3.2 model (may take several minutes depending on your connection).

### 3. Generate the demo

```bash
docker-compose -f docker-compose.demo.yml up demo
```

The demo GIF will be saved to `demo-output/demo.gif`.

### 4. Clean up

```bash
docker-compose -f docker-compose.demo.yml down
```

## Files

- `Dockerfile.demo` - Docker image with LTS binary and VHS
- `docker-compose.demo.yml` - Orchestrates Ollama and demo generation
- `.lts.json.demo` - LTS configuration for Ollama
- `demo.tape` - VHS recording script
- `generate-demo.sh` - Automated script to generate the demo

## Customization

To modify the demo recording:

1. Edit `demo.tape` to change the commands or timing
2. Run `./generate-demo.sh --copy` to regenerate

To use a different Ollama model:

1. Edit `.lts.json.demo` and change the `model` field
2. Edit `docker-compose.demo.yml` and update the model pull command
3. Regenerate the demo
