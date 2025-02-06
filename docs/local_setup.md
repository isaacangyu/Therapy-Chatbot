# Local Setup Guide

This guide provides a high-level overview of *one way* to set up this project for local development.  

> This guide uses dev containers. You can read more about dev containers [here](https://containers.dev/).

1. Install [Docker](https://www.docker.com/).
    - On **Windows machines**, this will require that you also **first install** [WSL2](https://learn.microsoft.com/en-us/windows/wsl/) and create a default distribution (i.e. Ubuntu).
    - Verify that you are [using the WSL2 based engine](https://docs.docker.com/desktop/features/wsl/#turn-on-docker-desktop-wsl-2).
2. Install [Visual Studio Code](https://code.visualstudio.com/). You can use a different editor, but may have to install additional tooling. See [here](https://containers.dev/supporting) for details.
3. Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VSCode. This page also contains a guide for installing Docker.
4. Install the [Dart Debug Extension](https://chromewebstore.google.com/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm). This browser extension only works on Chromium-based web browsers (i.e. Edge, Chrome).
5. Follow the local devcontainer guide in [`fdp_instructions.md`](./fdp_instructions.md).

> [!Note]
> Flutter makes a distinction between the functions "hot restart" and "hot reload". This guide sets up an environment that uses a web browser as the frontend. The VSCode extension for Flutter will inform you that it is "hot reloading", but it is really "hot restarting", since the former isn't supported on web.
