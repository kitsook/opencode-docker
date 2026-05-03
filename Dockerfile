FROM ghcr.io/anomalyco/opencode

# Install system dependencies using apk (Alpine)
RUN apk update && apk add --no-cache \
    git \
    curl \
    wget \
    build-base \
    ca-certificates \
    jq \
    unzip \
    tar \
    python3 \
    py3-pip \
    nodejs \
    npm

# Install Python development tools
# Using --break-system-packages because this is a dedicated container environment
RUN pip3 install --no-cache-dir --break-system-packages \
    ruff \
    black \
    pytest \
    mypy

# Install TypeScript/Node development tools
RUN npm install -g \
    typescript \
    eslint \
    prettier

# Set the working directory
WORKDIR /app
