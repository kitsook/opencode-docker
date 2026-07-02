# Build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=opencodeuser

FROM ghcr.io/anomalyco/opencode:1.17.13

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
    shadow \
    unzip \
    xz \
    zip \
    glu glu-dev \
    openjdk21-jdk \
    bash \
    libstdc++ \
    gcompat \
    libc6-compat

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

# flutter dev
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$PATH:$FLUTTER_HOME/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Download and install Android Command Line Tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -O cmdline-tools.zip "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" && \
    unzip cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Accept Android licenses and install SDK packages
#RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
#    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-36" "build-tools;28.0.3" "ndk;28.2.13676358"

# Install the Flutter SDK (Stable Channel)
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME} && \
    git config --global --add safe.directory ${FLUTTER_HOME}

# Pre-download Flutter tools and accept Flutter-specific Android licenses
RUN flutter config --no-analytics && \
    flutter precache && \
    yes "y" | flutter doctor --android-licenses && \
    flutter doctor -v

RUN git config --global --add safe.directory /opt/flutter && \
  chown -R ${USER_NAME} /opt/flutter /opt/android-sdk

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
