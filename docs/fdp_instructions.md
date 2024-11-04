# fdp_template
This repository contains devcontainer configuration files for a Flutter + Django & PostgreSQL project.  
The devcontainer is compatible with both GitHub Codespaces and a locally running devcontainer.

## Usage
1. Create a new repo from this template.
> Important: The automated project structure setup will fail if the repo name contains non-alphanumeric characters (aside from underscores).
2. Specify package versions (ignore for default versions):
    - Specify the desired Flutter version using the `FLUTTER_VERSION` environment variable in `.devcontainer/Dockerfile`.
    - Specify the desired Django version in `requirements.txt`.
    - All other package versions will likely require modifying the base image used by the Dockerfile.
3. (Optional) If the devcontainer will be run locally, install the [Dart Debug Extension](https://chrome.google.com/webstore/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm).
4. Create a devcontainer either locally or with GitHub Codespaces.

### Running the App
> Use the command palette (<kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>P</kbd>) to search and select "Run Task" to see a list of configured tasks.

#### Local devcontainer
1. Run the "Start Backend" task to start the Django web server.
2. Navigate to the debug side bar and launch the "Flutter Run Debug" configuration.
3. Once the Flutter web server has started, open `localhost:3000` in a browser to view the Flutter app.
4. Activate the Dart Debug extension.
5. (Optional) Open `localhost:8000` to access Django web interfaces.
- To hot **reload** the Flutter app, press <kbd>CTRL</kbd>+<kbd>S</kbd> (even if autosave is enabled; this can be changed in the VSCode settings).

#### GitHub Codespace
1. Run the "Start Servers" task to start both the Flutter and Django web servers.
2. Once the Flutter web server has started, Open `localhost:3000` in a browser to view the Flutter app.
3. (Optional) Open `localhost:8000` to access Django web interfaces.
- To hot **restart** the Flutter app, press <kbd>r</kbd> in the task terminal.

## Tips
- If you are unable to access the Django web interface, try removing port 8000 from VSCode's list of forwarded ports, and then adding it back manually.
- Use the "Django Migrate" task to automatically apply database migrations.
- The Flutter web server can be launched independently from Django with the "Start Frontend" task.
- Follow the comments in `.devcontainer/devcontainer.json` and `.devcontainer/docker-compose.yml` to port forward PostgreSQL.
