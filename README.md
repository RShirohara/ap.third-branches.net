# `ap.third-branches.net`

## About

Deployment config and script for "[ap.third-branches.net](https://ap.third-branches.net)".

## Infrastructure

- App Hosting: AWS Lightsail Container
  - Power: `nano`
  - Scale: `1`
- DB: AWS Lightsail Database
  - Blueprint: PostgreSQL 15
  - Bundle: `micro`
- Media Hosting: Cloudflare R2
- Reverse Proxy: Cloudflare Tunnel

## Setup

### 1. Setup Infrastructures

1. Clone repository.
2. Create resources using Terraform.

   ```shell
   cd terraform
   terraform plan
   terraform apply
   ```

   Required value details: [`variables.tf`](./terraform/variable.tf)

### 2. Create Admin Account (First time only)

1. Save the values output during infrastructure setup to the `.env` file under `docker/environments/`.
   - `TUNNEL_TOKEN`: Token used to set up Cloudflare Tunnel.
   - `GTS_*`: Environment variables that configure the GoToSocial instance.
     - Details: [GoToSocial Configuration Overview](https://docs.gotosocial.org/en/latest/configuration/)
2. Start docker containers.

   ```shell
   cd docker
   docker compose up -d
   ```

3. Create admin account.
   - Details: [Official Document](https://docs.gotosocial.org/en/latest/getting_started/user_creation/)
