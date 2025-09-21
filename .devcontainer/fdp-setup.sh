#!/bin/bash

setup() {
    (
        set -e

        echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.bashrc

        export ANDROID_HOME=/usr/local/android_sdk
        echo 'export ANDROID_HOME='$ANDROID_HOME >> ~/.bashrc
        echo 'export PATH=$PATH:'$ANDROID_HOME'/cmdline-tools/latest:'$ANDROID_HOME'/cmdline-tools/latest/bin:'$ANDROID_HOME'/platform-tools' >> ~/.bashrc

        pipx install poetry && poetry install

        # Android Development Packages
        # Android Version: 15 (Vanilla Ice Cream)
        # API Level: 35
        yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platforms;android-35" "build-tools;35.0.0" "platform-tools"
        yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
    )
    return $?
}

setup

STATUS=$?
if [[ $STATUS -ne 0 ]]; then
    echo -e '\e[91;1mDev Container setup completed with errors. See the log above for details.\e[m'
    exit 1
else
    echo -e '\e[92;1mDev Container setup complete.\e[m'
fi
