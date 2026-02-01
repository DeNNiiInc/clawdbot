# AI AGENT Deployment Guide for OpenClaw

This guide describes the automated deployment process for OpenClaw using WSL and Docker.

## 🚨 Critical Security Warning
**NEVER commit `secrets.php` to Git.** This file contains sensitive credentials. Ensure it is listed in `.gitignore`.

## 1. Environment Requirements
- **Controller**: Windows with WSL (Ubuntu/Debian).
- **Target**: Ubuntu 24.04 LTS VM.
- **Tools Required**: `sshpass`, `git`, `wsl`, `ssh`.

## 2. Deployment Workflow

### Step 1: Local Preparation
Ensure the local repository is clean and `secrets.php` is configured locally for reference (but ignored).
```bash
# Check gitignore
grep "secrets.php" .gitignore || echo "secrets.php" >> .gitignore
```

### Step 2: Server Bootstrapping (One-Time)
Run these commands on the target server to prepare the environment.

**Command Template (WSL):**
```bash
wsl sshpass -p '<PASSWORD>' ssh root@<IP> "bash -s" < install_script.sh
```

**Key Installation Steps:**
1.  **Update System**: `apt-get update`
2.  **Dependencies**: `apt-get install -y git curl unzip`
3.  **Node.js**: `curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && apt-get install -y nodejs`
4.  **Docker**: `curl -fsSL https://get.docker.com | sh`
5.  **Cloudflare**: Install `cloudflared` and register service using token.

### Step 3: Application Setup
1.  **Clone Repository**:
    ```bash
    git clone https://<GITHUB_TOKEN>@github.com/DeNNiiInc/OpenClaw.git /root/OpenClaw
    ```
2.  **Inject Secrets**:
    Write the content of `secrets.php` to `/root/OpenClaw/secrets.php` using `cat` and heredoc via SSH.

### Step 4: Deployment
Execute the single-line deployment script. This pulls the latest code and rebuilds containers.

**Deploy Command:**
```bash
wsl sshpass -p '<PASSWORD>' ssh root@<IP> "cd /root/OpenClaw && ./deploy.sh"
```

## 3. The `deploy.sh` Script
The repository contains `deploy.sh` which handles:
1.  Generating default `.env` if missing.
2.  `git pull` to sync code.
3.  `docker compose up -d --build` to launch services.

## 4. Verification
Check running containers:
```bash
wsl sshpass -p '<PASSWORD>' ssh root@<IP> "docker compose -f /root/OpenClaw/docker-compose.yml ps"
```

## 5. Troubleshooting
- **Permission Denied**: Ensure `deploy.sh` is executable (`chmod +x deploy.sh`).
- **Env Errors**: Check `.env` file generation in `deploy.sh`.
- **Build Failures**: Check `docker compose logs`.
