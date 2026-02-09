### 1. What are Containers?
Containers are lightweight, isolated environments that package an application along with its dependencies (code, libraries, configurations) to run consistently across different computing environments. Unlike virtual machines (VMs), containers share the host OS kernel, making them faster, more efficient, and portable. They solve the "it works on my machine" problem by ensuring the same runtime environment everywhere—from development to production.

Key benefits:
- Isolation: Apps run independently without interfering.
- Portability: Move between local machines, servers, or clouds.
- Efficiency: Use fewer resources than VMs.
- Scalability: Easy to start/stop multiple instances.

For recall: Containers are like shipping containers for software—standardized, self-contained units that work anywhere.

### 2. What is Docker?
Docker is an open-source platform for building, shipping, and running containers. It provides tools to create container images (blueprints), run them as containers, and manage their lifecycle. Docker popularized container technology and includes a daemon (background service), CLI (command-line interface), and ecosystem like Docker Hub for sharing images.

Architecture components:
- **Docker Daemon (dockerd)**: Manages building, running, and distributing containers.
- **Docker Client (docker)**: CLI tool to interact with the daemon (e.g., `docker run`).
- **Images**: Read-only templates for containers.
- **Containers**: Running instances of images.
- **Registries**: Repositories like Docker Hub to store/pull images.

For recall: Docker is the "engine" that makes containers easy to use.

### 3. Installing Docker
Docker Desktop is the easiest way for beginners on Windows, Mac, or Linux. It includes the daemon, CLI, Compose, and a GUI.

#### General Steps:
1. Go to [docker.com](https://www.docker.com/products/docker-desktop/) and download the installer for your OS.
2. Run the installer and follow prompts (may require admin rights).
3. Verify installation: Open a terminal and run `docker --version` (should show version) or `docker run hello-world` (pulls and runs a test image).

#### Platform-Specific Notes:
- **Windows**: Requires Windows 10/11 Pro/Enterprise (with WSL 2 or Hyper-V). Enable WSL in Windows Features. Installer sets up everything.
- **Mac**: Supports Intel/Apple Silicon. Download .dmg, drag to Applications, launch, and sign in.
- **Linux**: Use package managers (e.g., apt for Ubuntu). Add Docker repo, install via `sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`. Start service with `sudo systemctl start docker`.

Post-install: Create a free Docker Hub account for pushing/pulling images. For recall: Installation is straightforward—download, install, test with `hello-world`.

### 4. Basic Docker Commands
Use the `docker` CLI for common tasks. Here's a cheat sheet table:

| Command | Description | Example |
|---------|-------------|---------|
| `docker pull <image>` | Download an image from a registry (e.g., Docker Hub). | `docker pull ubuntu` |
| `docker images` | List local images. | `docker images` |
| `docker run <image>` | Create and start a container from an image. | `docker run hello-world` |
| `docker run -it <image>` | Run interactively (attach terminal). | `docker run -it ubuntu /bin/bash` (starts Ubuntu shell) |
| `docker ps` | List running containers. | `docker ps` |
| `docker ps -a` | List all containers (running/stopped). | `docker ps -a` |
| `docker start/stop <container>` | Start or stop a container. | `docker stop mycontainer` |
| `docker rm <container>` | Remove a stopped container. | `docker rm mycontainer` |
| `docker rmi <image>` | Remove an image. | `docker rmi ubuntu` |
| `docker exec -it <container> <cmd>` | Run a command in a running container. | `docker exec -it mycontainer sh` (open shell) |
| `docker logs <container>` | View container logs. | `docker logs mycontainer` |
| `docker build -t <name> .` | Build an image from a Dockerfile. | `docker build -t myapp .` |

For recall: Start with `docker run hello-world` to test.

### 5. Writing a Dockerfile
A Dockerfile is a text file (no extension) with instructions to build an image. It defines the environment, dependencies, and startup command.

Common instructions (in order):
- `FROM`: Base image.
- `WORKDIR`: Set working directory.
- `COPY`: Copy files from host.
- `RUN`: Execute build-time commands (e.g., install packages).
- `EXPOSE`: Document ports.
- `CMD`: Default runtime command.

Example for a simple Node.js app:
```dockerfile
# syntax=docker/dockerfile:1
FROM node:24-alpine  # Base image
WORKDIR /app         # Working dir
COPY . .             # Copy app files
RUN npm install --omit=dev  # Install deps
CMD ["node", "src/index.js"]  # Startup command
EXPOSE 3000          # Port info
```

For recall: Dockerfiles build layers—order matters for caching.

### 6. Building and Running Containers
Build an image from a Dockerfile, then run it as a container.

Steps:
1. Clone example app: `git clone https://github.com/docker/getting-started-app.git`
2. Build: `docker build -t getting-started .` (`.` = current dir with Dockerfile)
3. Run detached with port mapping: `docker run -d -p 3000:3000 getting-started`
4. Access at http://localhost:3000
5. Stop: Find ID with `docker ps`, then `docker stop <ID>`

For recall: Build creates image; run creates container. Use `-p` for ports, `-d` for background.

### 7. Docker Hub and Sharing Images
Docker Hub is a public registry for images. Sign in, push/pull.

Example:
- Login: `docker login -u <username>`
- Tag: `docker tag getting-started <username>/getting-started`
- Push: `docker push <username>/getting-started`
- Pull elsewhere: `docker pull <username>/getting-started`

For recall: Hub is like GitHub for containers—share publicly or privately.

### 8. Docker Compose
Compose manages multi-container apps via a YAML file (compose.yaml). Ideal for apps with databases, etc.

Example Python Flask + Redis app:
- `app.py`: Flask code with Redis counter.
- `Dockerfile`: Builds Python image.
- `compose.yaml`:
```yaml
services:
  web:
    build: .
    ports:
      - "8000:5000"
  redis:
    image: "redis:alpine"
```
- Run: `docker compose up -d`
- Access: http://localhost:8000
- Down: `docker compose down`

For recall: Compose = one command for multi-services. Workflow diagram:

### 9. Volumes
Volumes persist data outside containers (e.g., for databases). Managed by Docker, better than bind mounts for portability.

Commands:
- Create: `docker volume create my-vol`
- Run with volume: `docker run -d --name db --mount source=my-vol,target=/data mysql`
- List: `docker volume ls`
- Remove: `docker volume rm my-vol`

In Compose:
```yaml
services:
  app:
    volumes:
      - myvol:/app/data
volumes:
  myvol:
```

For recall: Volumes survive container deletion—use for persistent storage.

### 10. Networking
Containers connect via networks. Default: bridge (isolated). Create custom for communication.

Commands:
- Create: `docker network create my-net`
- Run on network: `docker run --network my-net busybox`
- Connect: `docker network connect my-net <container>`
- Publish port: `docker run -p 80:80 nginx`

Types: bridge (default), host (share host network), none (isolated).

For recall: Networks link containers; use names for DNS resolution.

### 11. Best Practices
- Use official/small base images (e.g., alpine).
- Minimize layers in Dockerfile for faster builds.
- Run as non-root user.
- Clean up unused images/containers: `docker system prune`.
- Use .dockerignore to exclude unnecessary files.
- For production: Multi-stage builds, secrets management.
- Security: Scan images with `docker scan`.

For recall: Keep images small, secure, and versioned.



Here is a quick, one-line-per-command Docker cheat sheet for the main everyday activities (as of 2026). Commands use common flags; replace placeholders like `<image>`, `<container>`, etc.

**Show Docker version**  
`docker --version`

**Show detailed Docker info**  
`docker info`

**Pull an image from registry (e.g. Docker Hub)**  
`docker pull <image>[:tag]`

**List local images**  
`docker images` or `docker image ls`

**Build an image from Dockerfile in current directory**  
`docker build -t <image-name:tag> .`

**Build without cache**  
`docker build --no-cache -t <image-name:tag> .`

**Tag an existing image**  
`docker tag <source-image> <new-name:tag>`

**Push image to registry (e.g. Docker Hub)**  
`docker push <username>/<image:tag>`

**Login to Docker Hub or registry**  
`docker login` or `docker login -u <username>`

**Create (but do not start) a container**  
`docker create --name <container-name> <image>`

**Run a container (create + start)**  
`docker run <image>`

**Run in detached (background) mode**  
`docker run -d <image>`

**Run with custom name**  
`docker run --name <container-name> <image>`

**Run with port mapping**  
`docker run -p <host-port>:<container-port> <image>`

**Run interactively with terminal**  
`docker run -it <image> /bin/bash` or `sh`

**List running containers**  
`docker ps`

**List all containers (running + stopped)**  
`docker ps -a`

**Start a stopped container**  
`docker start <container-name-or-id>`

**Stop a running container**  
`docker stop <container-name-or-id>`

**Restart a container**  
`docker restart <container-name-or-id>`

**Remove a stopped container**  
`docker rm <container-name-or-id>`

**Remove running container forcefully**  
`docker rm -f <container-name-or-id>`

**Show logs of a container**  
`docker logs <container-name-or-id>`

**Follow logs in real time**  
`docker logs -f <container-name-or-id>`

**Execute command in running container**  
`docker exec <container> <command>`

**Open interactive shell in running container**  
`docker exec -it <container> /bin/bash` or `sh`

**Inspect container or image details**  
`docker inspect <container-or-image>`

**Show resource usage stats**  
`docker stats`

**Remove unused (dangling) images**  
`docker image prune`

**Remove all stopped containers, unused images, networks, etc.**  
`docker system prune`

**Remove all unused volumes**  
`docker volume prune`

**Search for images on Docker Hub**  
`docker search <keyword>`

**Copy files from container to host**  
`docker cp <container>:/path/inside/container /host/path`

**Copy files from host to container**  
`docker cp /host/path <container>:/path/inside/container`

**Save a image locally as .tar file**  
`docker save -o <export_filename.tar> <image-name:tag>`

**Load a image from a .tar file**  
`docker load -i export_filename.tar`


This covers ~95% of daily Docker usage for images, containers, and basic cleanup. Use `docker --help` or `docker <command> --help` for more flags/options.