# Specification: Custom Opencode Docker Environment

## Objective
Create a custom Docker image based on `ghcr.io/anomalyco/opencode` that includes essential development tools for Python and TypeScript, and provide a `docker-compose.yml` for easy orchestration.

## Toolset

### Essential Tools (Base)
- `git`: Version control
- `curl`, `wget`: Data retrieval
- `build-base`: Compilers (gcc, make)
- `ca-certificates`: Secure HTTPS
- `jq`: JSON processor
- `unzip`, `tar`: Archive handling

### Python Development
- `python3`, `py3-pip`
- `ruff`: Linter/formatter
- `black`: Formatter
- `pytest`: Testing
- `mypy`: Static type checking

### TypeScript/Node.js Development
- `nodejs`, `npm`
- `typescript`: TS compiler
- `eslint`: Linter
- `prettier`: Formatter

## Files to be created
1. `Dockerfile`: The build instruction.
2. `docker-compose.yml`: For easy deployment.
3. `spec.md`: This specification file.

## Implementation Details

### Dockerfile Strategy
- Base image: `ghcr.io/anomalyco/opencode`
- Use `apk` to install system dependencies (Alpine).
- Use `pip` to install Python tools.
- Use `npm` to install TypeScript tools.

### Docker Compose Strategy
- Map host volumes for configuration and working directory to match the user's current setup.
- Use `network_mode: host` as requested.
- Map `.local/share/opencode`, `.config/opencode/AGENTS.md`, `.config/opencode/opencode.json`, `.config/opencode/prompts/build.txt`, and current directory `.`.
