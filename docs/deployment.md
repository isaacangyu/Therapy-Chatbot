# Deployment (Tentative)

1. Switch from Premium Tier to Standard Tier networking (greater free egress rate) [[1](https://docs.cloud.google.com/network-tiers/docs/set-network-tier#setting_the_tier_for_all_resources_in_a_project)]
1. Configure VPC for Cloud Run instances to connect to the Compute Engine VM [[1](https://docs.cloud.google.com/vpc/docs/create-modify-vpc-networks)] [[2](https://docs.cloud.google.com/run/docs/configuring/vpc-direct-vpc)]
1. Configure Compute Engine instance with git, Docker, and Python installed [[1](https://docs.cloud.google.com/compute/docs/create-linux-vm-instance)]
   ```sh
   sudo apt install git python3
   ```
   [Docker installation](https://docs.docker.com/desktop/setup/install/linux/debian/)
1. Clone project
1. Set service usernames, passwords and run Docker services
1. Obtain Gemini API key [[1](https://aistudio.google.com/app/apikey)]
1. Install Python dependencies, create temporary `.env` with API key, and set up Postgres, Neo4J
   ```sh
   pipx install poetry
   
   ./scripts/poetry-install.sh
   ./scripts/django-migrate.sh
   ./scripts/init-graphiti.py
   ```
1. Generate RSA keys:
   ```sh
   mkdir -p cert/prod/private
   mkdir -p cert/prod/public
   openssl genpkey -algorithm RSA -out cert/prod/private/private.pem -pkeyopt rsa_keygen_bits:3072
   openssl rsa -in cert/prod/private/private.pem -pubout -out cert/prod/public/public.pem
   ```
1. Configure Cloud Run secrets using Secret Manager: `RSA_PRIVATE_KEY`, `ENV_FILE` (fill out production variables) [[1](https://docs.cloud.google.com/secret-manager/docs/creating-and-accessing-secrets)] [[2](https://docs.cloud.google.com/run/docs/configuring/services/secrets)]
1. Commit and push public RSA key only to the production branch.
1. Set up Cloud Run on prod and trigger build, deployment; update secrets if necessary
1. Add firewall rules as needed [[1](https://docs.cloud.google.com/firewall/docs/using-firewalls)]
1. Adjust configurations in `app_assets` and `api`
1. Use GH Actions to build app artifacts from prod
1. Use GH Actions to build static web app and static asset API from prod
1. Configure GH Pages to serve assets from prod
