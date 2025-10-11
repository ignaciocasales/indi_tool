# Use official Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_ROOT=/opt/flutter

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    xz-utils \
    build-essential \
    cmake \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libglu1-mesa \
    libglu1-mesa-dev \
    wget \
    ninja-build \
    clang \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -ms /bin/bash flutter
# Set permissions for Flutter SDK directory
RUN mkdir -p $FLUTTER_ROOT && chown -R flutter:flutter $FLUTTER_ROOT
# Switch to non-root user
USER flutter
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH="$FLUTTER_ROOT/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin:$PATH"
# Set working directory
WORKDIR /home/flutter

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_ROOT -b stable

# Enable Linux desktop support
RUN flutter config --enable-linux-desktop
RUN flutter doctor -v

# Copy your project
COPY --chown=flutter:flutter . /home/flutter/app
WORKDIR /home/flutter/app

# Make output folder
RUN mkdir -p /home/flutter/output

# Build and zip Linux release
RUN flutter pub get && \
    flutter build linux --release && \
    cd build/linux/x64/release/bundle && \
    zip -r /home/flutter/output/MyApp-linux.zip *

# Expose output folder as volume
VOLUME /home/flutter/output

CMD ["bash"]
