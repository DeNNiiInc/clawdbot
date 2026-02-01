# Deployment Notes

## Issues Encountered & Resolutions

1.  **Line Endings (CRLF vs LF)**:
    - *Issue*: `server_setup_generated.sh` failed when piped to WSL because Windows uses CRLF, and `bash` inside the Linux VM rejected `\r`.
    - *Resolution*: Used `tr -d '\r'` in the pipeline to strip carriage returns before passing to `ssh`.

2.  **Git Permissions & Merge Conflicts**:
    - *Issue*: `deploy.sh` created locally and pushed. On server, `chmod +x` modified file permissions, causing a "local changes" error when pulling the updated script.
    - *Resolution*: Forced a clean state on the server using `git reset --hard origin/main` before pulling.

3.  **Missing `docker-compose` Build Context**:
    - *Issue*: `docker-compose.yml` referenced `image: openclaw:local` but lacked `build: .`, potentially failing the build.
    - *Resolution*: Added `build: .` to `docker-compose.yml` and pushed.

4.  **Missing Environment Variables**:
    - *Issue*: Deployment failed due to missing volumes configuration (`OPENCLAW_CONFIG_DIR`, etc.) leading to invalid docker specs.
    - *Resolution*: Updated `deploy.sh` to automatically generate a `.env` file with default values if it's missing.

## Current State
- **Server**: 172.16.69.235
- **Status**: Docker containers built and running.
- **Workflow**: `deploy.sh` handles git sync, env generation, and docker composition.
