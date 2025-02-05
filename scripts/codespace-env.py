#!/usr/bin/env python3

import os

codespace_name = os.environ["CODESPACE_NAME"]
port_forwarding_domain = os.environ["GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN"]

init_base_url = f"https://{codespace_name}-5000.{port_forwarding_domain}"
base_url = f"https://{codespace_name}-8000.{port_forwarding_domain}"
frontend_domain = f"https://{codespace_name}-3000.{port_forwarding_domain}"

with open("./app_assets/config_template.json", "r") as fin:
    s = fin.read().replace("{{ INIT_BASE_URL }}", init_base_url)
    with open("./app_assets/config.json", "w") as fout:
        fout.write(s)

with open("./api/base_url_template.json", "r") as fin:
    s = fin.read().replace("{{ BASE_URL }}", base_url)
    with open("./api/base_url.json", "w") as fout:
        fout.write(s)

with open("./scripts/start-api-test-backend_template.py", "r") as fin:
    s = fin.read().replace("{{ FRONTEND_DOMAIN }}", frontend_domain)
    with open("./scripts/start-api-test-backend.py", "w") as fout:
        fout.write(s)
    os.system("chmod +x ./scripts/start-api-test-backend.py")

print("""
Successfully applied Codespace compability edits.

\033[91;1mAlways remember to set your forwarded ports to public!\033[m
""")
