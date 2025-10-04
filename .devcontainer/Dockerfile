ARG DESKTOP_CONFIG_PARENT=devcontainer_base
ARG ANDROID_CONFIG_PARENT=devcontainer_desktop

# "None" Installation
FROM mcr.microsoft.com/devcontainers/python:1-3.11-bookworm AS devcontainer_none

# No additional setup.

# Base / Web Installation
FROM devcontainer_none AS devcontainer_base

ENV FLUTTER_VERSION="3.29.0-stable"
ENV ANDROID_HOME="/usr/local/android_sdk"
ENV SKIP_POST_CREATE=0

ENV PYTHONUNBUFFERED=1

# [Optional] If your requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# Additional OS packages.
RUN echo "Building base installation." && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl git unzip xz-utils zip libglu1-mesa

# Install Flutter.
RUN wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" \
    && tar -xf "flutter_linux_${FLUTTER_VERSION}.tar.xz" -C /usr/local/ \
    && rm "flutter_linux_${FLUTTER_VERSION}.tar.xz"

# Desktop Installation
FROM $DESKTOP_CONFIG_PARENT AS devcontainer_desktop

RUN echo "Building desktop installation." && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    clang cmake git \
    ninja-build pkg-config \
    libgtk-3-dev liblzma-dev \
    libstdc++-12-dev \
    # The packages below are required for `flutter_secure_storage`.
    libsecret-1-dev libjsoncpp-dev libsecret-1-0 gnome-keyring dbus-x11

# Android Installation
FROM $ANDROID_CONFIG_PARENT AS devcontainer_android

RUN echo "Building Android installation." && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends openjdk-17-jdk-headless gradle

# Install Android command line tools.
# Docs: https://developer.android.com/tools/sdkmanager
RUN wget "https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip" \
    && unzip commandlinetools-linux-*.zip -d cmdline-tools \
    && mkdir -p $ANDROID_HOME/cmdline-tools/latest \
    && mv cmdline-tools/cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest \
    && rm -r commandlinetools-linux-*.zip cmdline-tools \
    && chown -R 1000:1000 $ANDROID_HOME
