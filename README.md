# Custom Opencode Docker Environment

This repository provides a customized Docker environment for running [Opencode](https://github.com/anomalyco/opencode). While the official image is lightweight, this setup adds a comprehensive suite of development tools for **Python** and **TypeScript/Node.js**, making it a ready-to-use sandbox for coding tasks.

## Features

- **Base Image**: `ghcr.io/anomalyco/opencode` (Alpine Linux based)
- **Essential Tools**: `git`, `curl`, `wget`, `build-base`, `jq`, `unzip`, `tar`
- **Python Stack**: `python3`, `pip`, `ruff`, `black`, `pytest`, `mypy`
- **TypeScript/Node Stack**: `nodejs`, `npm`, `typescript`, `eslint`, `prettier`
- **Easy Orchestration**: Uses `docker-compose` for simplified management.

## Quick Start

### 1. Prerequisites

Ensure you have [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.

### 2. Setup

Clone this repository to your local machine:

```bash
git clone <repository-url>
cd <repository-directory>
```

### 3. Build the Custom Image

Build the image containing all the development tools:

```bash
docker compose build
```

### 4. Run Opencode

Since `opencode` is an interactive CLI tool, use the `run` command to start it:

```bash
docker compose run --rm opencode
```

To pass specific arguments to the `opencode` command:

```bash
docker compose run --rm opencode <your-arguments>
```

## Configuration

The `docker-compose.yml` file is configured to map your local user's configuration and working directory into the container:

- `${HOME}/.local/share/opencode` $\rightarrow$ `/root/.local/share/opencode`
- `${HOME}/.config/opencode/*` $\rightarrow$ `/root/.config/opencode/*`
- `.` (current directory) $\rightarrow$ `/app`

*Note: If your configuration paths differ, please update the `volumes` section in `docker-compose.yml`.*

## Troubleshooting

**"The CLI is not showing/responsive"**

If you try to use `docker compose up`, the container will start in the background and you won't see the interactive prompt. Always use `docker compose run --rm opencode` for interactive sessions.
