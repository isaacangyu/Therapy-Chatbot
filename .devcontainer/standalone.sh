#!/bin/bash

# This script is intended to convert the "None" configuration into the "Desktop" configuration
# in case an anomaly occurs while building the Dockerfile.

export FLUTTER_VERSION="3.29.0-stable"
export SKIP_POST_CREATE=0

echo "Building base installation." && sudo apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get -y install --no-install-recommends curl git unzip xz-utils zip libglu1-mesa

# Install Flutter.
wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" \
    && sudo tar -xf "flutter_linux_${FLUTTER_VERSION}.tar.xz" -C /usr/local/ \
    && rm "flutter_linux_${FLUTTER_VERSION}.tar.xz"

echo "Building desktop installation." && export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get -y install --no-install-recommends \
    clang cmake git \
    ninja-build pkg-config \
    libgtk-3-dev liblzma-dev \
    libstdc++-12-dev \
    libsecret-1-dev libjsoncpp-dev libsecret-1-0 gnome-keyring dbus-x11

bash .devcontainer/fdp-setup.sh --desktop
