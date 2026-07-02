# Custom Opencode Docker Environment

A customized Docker environment for `opencode` based on Alpine Linux, including Python and TypeScript development tools.

This repo is not affiliated with the official OpenCode.

## Features

- **Base Image**: `ghcr.io/anomalyco/opencode` (Alpine Linux based)
- **Essential Tools**: `git`, `curl`, `wget`, `build-base`, `jq`, `unzip`, `tar`
- **Python Stack**: `python3`, `pip`, `ruff`, `black`, `pytest`, `mypy`
- **TypeScript/Node Stack**: `nodejs`, `npm`, `typescript`, `eslint`, `prettier`
- **Android Flutter Stack**: `flutter`
- **Easy Orchestration**: Uses `docker-compose` for simplified management.

## Quick Start

### 1. Prerequisites

Ensure you have [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.

### 2. Build the Custom Image

Because the user ID and group ID are baked into the image to ensure correct file ownership, you must build the image using your current host's `UID` and `GID`.

```bash
UID=$(id -u) GID=$(id -g) docker compose build
```

### 3. Run Opencode

Once built, you can run the `opencode` command in the current directory:

```bash
docker compose run --rm opencode
```

To run `opencode` on a different project folder without moving the `docker-compose.yml` file, set the `APP_DIR` environment variable:

```bash
# From within your target project folder
APP_DIR=$(pwd) docker compose -f /path/to/opencode-docker/docker-compose.yml run --rm opencode
```

To pass specific arguments to the `opencode` command:

```bash
docker compose run --rm opencode <your-arguments>
```

## Configuration

The following files are mapped from your host to the container:

- `~/.local/share/opencode` $\to$ `/home/opencodeuser/.local/share/opencode`
- `~/.local/state/opencode` $\to$ `/home/opencodeuser/.local/state/opencode`
- `~/.config/opencode/AGENTS.md` $\to$ `/home/opencodeuser/.config/opencode/AGENTS.md`
- `~/.config/opencode/opencode.json` $\to$ `/home/opencodeuser/.config/opencode/opencode.json`
- `~/.config/opencode/prompts/build.txt` $\to$ `/home/opencodeuser/.config/opencode/prompts/build.txt`
- Current directory $\to$ `/app`

## Troubleshooting

**"The CLI is not showing/responsive"**

If you try to use `docker compose up`, the container will start in the background and you won't see the interactive prompt. Always use `docker compose run --rm opencode` for interactive sessions.
