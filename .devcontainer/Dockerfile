FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

ENV FLUTTER_VERSION "3.24.4-stable"

ENV PYTHONUNBUFFERED 1

# [Optional] If your requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# Additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl git unzip xz-utils zip libglu1-mesa

# Install Flutter.
RUN wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" \
    && tar -xf "flutter_linux_${FLUTTER_VERSION}.tar.xz" -C /usr/local/ \
    && rm "flutter_linux_${FLUTTER_VERSION}.tar.xz"
