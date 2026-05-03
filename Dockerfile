# Build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=opencodeuser

FROM ghcr.io/anomalyco/opencode

# Re-declare ARGs after FROM
ARG USER_ID
ARG GROUP_ID
ARG USER_NAME

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
    npm \
    shadow

# Create the group and user with specified UID/GID
RUN groupadd -o -g ${GROUP_ID} ${USER_NAME} && \
    useradd -o -u ${USER_ID} -g ${USER_NAME} -m -s /bin/sh ${USER_NAME}

# Create necessary directories and set ownership
RUN mkdir -p /home/${USER_NAME}/.local/share/opencode \
             /home/${USER_NAME}/.config/opencode/prompts \
             /home/${USER_NAME}/.local/state/opencode && \
    chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

# Install Python development tools
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

# Copy and prepare the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory
WORKDIR /app

# Set the HOME environment variable and switch to user
ENV HOME=/home/${USER_NAME}
USER ${USER_NAME}

# Use the custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
