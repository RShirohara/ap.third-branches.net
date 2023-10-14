# `ap.third-branches.net`

## About

Deployment config and script for "[ap.third-branches.net](https://ap.third-branches.net)".

## Infrastructure

- App Hosting: AWS Lightsail Instance
  - Blueprint: CentOS 9 Stream
  - Bundle: `micro`
- DB: AWS Lightsail Database
  - Blueprint: PostgreSQL 15
  - Bundle: `micro`
- Image and Video Hosting
  - AWS S3 Bucket
- Reverse Proxy
  - Cloudflare Tunnel

## Setup

### 1. Setup Infrastructures

1. Clone repository.
2. Create resources using Terraform.

   ```bash
   cd terraform
   terraform plan
   terraform apply
   ```

   Required value details: [`variables.tf`](./terraform/variable.tf)

3. Check the output values to use when setting up a GoToSocial instance.

   Output value details: [`output.tf`](./terraform/output.tf)

### 2. Setup GoToSocial Instance

1. Login to created Lightsail instance.
2. Install docker and docker-compose.
   - Reference: [Official Document](https://docs.docker.com/engine/install/centos/)
3. Clone repository on Lightsail instance.
4. Save the values output during infrastructure setup to the `.env` file.
   - `CLOUDFLARE_TUNNEL_TOKEN`: Token used to set up Cloudflare Tunnel.
   - `GTS_*`: Environment variables that configure the GoToSocial instance.
     - Details: [GoToSocial Configuration Overview](https://docs.gotosocial.org/en/latest/configuration/)
5. Start docker containers.

   ```bash
   docker compose up -d
   ```

## Administration Tasks

### 1. Update docker images

1. Login to Lightsail instance.
2. Stop docker containers.

   ```bash
   docker compose down
   ```

3. Pull docker images.

   ```bash
   docker compose pull
   ```

4. Restart docker containers.

   ```bash
   docker compose up -d
   ```
