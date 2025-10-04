#!/bin/bash

# Parse command line options.
while [[ $# -gt 0 ]]; do
    case "$1" in
        --android)
            ANDROID_ENABLED=1
            ;;
        --desktop)
            DESKTOP_ENABLED=1
            ;;
        *)
            echo "Invalid option: $1"
            exit 1
            ;;
    esac
    shift
done
        

echo "Android Enabled: $([[ "$ANDROID_ENABLED" ]] && echo 'true' || echo 'false')"
echo "Desktop Enabled: $([[ "$DESKTOP_ENABLED" ]] && echo 'true' || echo 'false')"

setup() {
    (
        set -e

        echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.bashrc
        echo 'export PATH=$PATH:'$ANDROID_HOME'/cmdline-tools/latest:'$ANDROID_HOME'/cmdline-tools/latest/bin:'$ANDROID_HOME'/platform-tools' >> ~/.bashrc

        pipx install poetry
        ./scripts/poetry-install.sh
        ./scripts/django-migrate.sh
        ./scripts/init-graphiti.py
        ./scripts/flutter-enforce-lockfile.sh

        # Android Development Packages
        # Flutter will automatically install the versions for:
        # platforms, build-tools, ndk, cmake.
        # during its first Android run.
        if [[ "$ANDROID_ENABLED" ]]; then
            echo "Installing Android development packages..."
            yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools"
            yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
            # Will automatically install remaining packages.
            /usr/local/flutter/bin/flutter build apk
        fi
        
        # Fix a small bug in how Flutter interacts with CMake during the desktop build process.
        # https://github.com/flutter/flutter/issues/59890
        if [[ "$DESKTOP_ENABLED" ]]; then
            echo "Preparing desktop building..."
            /usr/local/flutter/bin/flutter clean
        fi
    )
    return $?
}

[[ "$SKIP_POST_CREATE" -eq 0 ]] && setup || echo "SKIP_POST_CREATE is set. Skipping setup."

STATUS=$?
if [[ $STATUS -ne 0 ]]; then
    echo -e '\e[91;1mDev Container setup completed with errors. See the log above for details.\e[m'
    exit 1
else
    echo -e '\e[92;1mDev Container setup complete.\e[m'
fi
