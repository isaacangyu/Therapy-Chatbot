#!/bin/bash

setup() {
    (
        set -e

        echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.bashrc
        echo 'export PATH=$PATH:'$ANDROID_HOME'/cmdline-tools/latest:'$ANDROID_HOME'/cmdline-tools/latest/bin:'$ANDROID_HOME'/platform-tools' >> ~/.bashrc

        pipx install poetry && poetry install

        # Android Development Packages
        # Flutter will automatically install the versions for:
        # platforms, build-tools, ndk, cmake.
        # during its first Android run.
        yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools"
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
