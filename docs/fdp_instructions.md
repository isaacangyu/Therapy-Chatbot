# Dev Container Guide

This Dev Container is compatible with both GitHub Codespaces and a locally running devcontainer.

> If prompted at any point, the Flutter SDK path should be `/usr/local/flutter/`.

## Running the App
> Use the command palette (<kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>P</kbd>) to search and select "Run Task" to see a list of configured tasks.

### Local Dev Container
**See the [setup guide](./local_setup.md).**
1. Make sure you have the VS Code Dev Containers extension installed. Create a Dev Container in Remote Explorer and Clone repository in container volume. Set a descriptive name for the volume and keep hitting enter.
2. Once connected to the initial container, use the command palette to access the "Switch Container" menu. Switch to a container with your preferred development platform. This option is intended for machine which may struggle to support the Android emulator. All options have web support.
- If you choose to use the "Full" or "Android" containers, be sure you have adequate storage (32 GB free) and memory (8 GB free).
- Before switching to the Android container, follow the steps in [these docs](https://developer.android.com/studio/run/emulator-acceleration#vm-linux
) to enable KVM acceleration on Windows and Linux machines.
    - Summary: Install the required packages, run `sudo modprobe kvm_<arch>`, verify with `kvm-ok`.
3. Wait for the post creation script to finish.
4. Run the "Start API Test Backend" and "Start Backend" tasks to start the Django web server (or "Start All Backends").

#### Desktop
5. Navigate to the debug side bar and launch the "Flutter Run Desktop Debug" configuration.
6. You do not need to provide a keyring password if asked, just click "Continue".
- To hot **reload** the Flutter app, press <kbd>CTRL</kbd>+<kbd>S</kbd> (even if autosave is enabled; this can be changed in the VSCode settings).

#### Android
5. Open port 6080. If a window containing the booting Android device is not present: right click on the interface, open a terminal, and run `./restart-emulator.sh`.
6. Run the "[STABLE] Flutter Run Android Debug" task.
- On Codespaces, you may need to remove port 6080, and then readd it when encountering 5XX errors.
    - You can also use the "Flutter Run Android Debug" configuration here.
- To hot **reload** the Flutter app, press <kbd>r</kbd> in the terminal.

#### Web
5. Navigate to the debug side bar and launch the "Flutter Run Web Debug" configuration.
6. Once the Flutter web server has started, open `localhost:3000` in a browser to view the Flutter app.
7. Make sure you have the Dart Debug chrome extension installed. Activate (by clicking) the Dart Debug extension and clicking any blank space in the browser. The website should open load. 
8. (Optional) Open `localhost:8000` to access Django web interfaces.
- To hot **restart** the Flutter app, press <kbd>CTRL</kbd>+<kbd>S</kbd> (even if autosave is enabled; this can be changed in the VSCode settings).

___

To close your container, open the command palette and use "Close Remote Connection".

### [LEGACY] GitHub Codespace (Web)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/isaacangyu/Therapy-Chatbot?quickstart=1)

1. Run the "Apply Codespace Compatibility" task. This will automatically apply edits to make this project work in GitHub Codespaces.  
Note that Codespaces is intended to help with initial development efforts, but a local setup is recommended.
2. Run the "Start Servers" task to start both the Flutter and Django web servers (if `flutter` is not found, run `bash scripts/start-all.sh` in the terminal).
3. Once the Flutter web server has started, Open `localhost:3000` in a browser to view the Flutter app.
4. (Optional) Open `localhost:8000` to access Django web interfaces.
- To hot **restart** the Flutter app, press <kbd>r</kbd> in the task terminal.

## Tips
- If you receive an HTTP 401 status code when attempting to access Flutter via port 3000 in Codespaces, try making the forwarded port public (under Ports).
- To allow the frontend on port 3000 to make requests to the backend, set port 8000 to public as well. 
- If you are unable to access the Django web interface, try removing port 8000 from VSCode's list of forwarded ports, and then adding it back manually.
- Use the "Django Migrate" task to automatically apply database migrations.
- Make sure the first section of `flutter doctor -v` is green. 
- The Flutter web server can be launched independently from Django with the "Start Frontend" task.
- If `localhost:3000` is a blank screen, wait for a while. If nothing, try refresh (<kbd>CTRL</kbd>+<kbd>R</kbd>), then hard refresh (<kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>R</kbd>). If still nothing, rerun the bash command 2-3 times and repeat. 
- Follow the comments in `.devcontainer/devcontainer.json` and `.devcontainer/docker-compose.yml` to port forward PostgreSQL.
