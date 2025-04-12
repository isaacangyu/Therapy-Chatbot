# Firebase Studio / IDX Guide

Google's [**Project IDX**](https://idx.google.com/) (now a part of Google's **Firebase Studio**) can be used to supplement this project's Dev Container environment by providing convenient means of testing the app on an Android emulator.  
IDX configuration files and environment data (once initialized) can be found under `.idx/`.
> [!Note]
> "*Firebase Studio is in Preview, which means that the product is not subject to any SLA or deprecation policy and could change in backwards-incompatible ways.*"

## Quick Start
1. Go to [firebase.studio](https://firebase.studio/), create an account, and accept Google's terms of service.
2. Click "Import Repo" and paste the URL of this project. Check the box indicating that this is a Flutter project.
3. Accept the Android SDK licensing terms.
4. Once your workspace has been created, the Flutter daemon and Android emulator should automatically start.  
**It will take a while** for your app to assemble and be loaded into the emulator, but subsequent usage will be much faster.  
If you do not see the Android emulator panel, use the command pallette (<kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>P</kbd>) to show it with "Show Android Emulator Preview".
5. Create a PostgreSQL database with the VSCode task "IDX: Initialize Database". This task only needs to be run once.
    - Each time you start your workspace, run the task "IDX: Start Postgres" to start the database.
    - Additional tasks available are prefixed with "IDX: ".
6. Start backend servers (tasks: "Start API Test Backend" & "Start Backend").

> [!Note]
> Flutter will perform **hot reloads** as opposed to **hot restarts** with the Android Emulator. This loads UI changes faster and preserves the app's state between reloads. To hard restart the app, using the command pallette to run "Firebase Studio: Hard Restart Previews".

## Tips
- Go to the output panel and view the log "IDX" to see messages from the app and other vital development info.
- Firebase Studio / IDX comes with Gemini AI assistance built-in.
