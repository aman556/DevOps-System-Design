# Docker Lab Guide

This lab will introduce you to Docker and the fundamentals of containerization. You'll learn about key Docker concepts, important commands, and how to create and run a Docker container with hands-on steps.

---

## 1. What is Containerization?

**Containerization** is a technology that allows you to package and run applications and their dependencies in isolated environments called containers. Unlike virtual machines, containers share the host operating system's kernel but have their own filesystem, processes, and network stack. This ensures consistency across environments and makes applications portable and lightweight.

---

## 2. Docker

**Docker** is the most popular platform used for containerization. It provides tools to build, ship, and run containers efficiently. Docker simplifies deploying applications by packaging everything needed to run them (code, libraries, system tools) into containers.

---

## 3. Docker CLI

**Docker CLI** is the Command Line Interface provided by Docker to interact with the Docker engine. It allows you to build images, manage containers, networks, volumes, and perform other Docker-related tasks.

*Example command:*
```bash
docker --version
```

---

## 4. Dockerfile

A **Dockerfile** is a text file containing instructions to build a Docker image. Each instruction in a Dockerfile creates a layer in the image.

*Example Dockerfile:*
```Dockerfile
# Use official Python image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy file
COPY hello.py .

# Run a command
CMD ["python", "hello.py"]
```

---

## 5. Docker Image

A **Docker image** is a lightweight, standalone, and executable software package that includes everything needed to run a piece of software, including the code, runtime, libraries, and dependencies. Images are built from Dockerfiles.

*Build command:*
```bash
docker build -t my-python-app .
```

---

## 6. Docker Container

A **Docker container** is a runnable instance of a Docker image. Containers are isolated from each other and the host system, but they can communicate through defined channels.

*Run command:*
```bash
docker run --name my-running-app my-python-app
```

---

## 7. Docker Registry

A **Docker registry** is a storage and distribution system for Docker images. It allows you to share images within your organization or with the public. The most popular public registry is [Docker Hub](https://hub.docker.com/), but you can also set up private registries.

### Common Docker Registry Terms
- **Docker Hub:** The default public registry for Docker images.
- **Repository:** A collection of Docker images with the same name but different tags (versions).
- **Tag:** A label for a specific image version (e.g., `latest`, `v1.0`).

#### Examples of Registries
- **Public:** Docker Hub, GitHub Container Registry, Google Container Registry, Amazon ECR, etc.
- **Private:** Self-hosted Docker Registry, Harbor, etc.

---

## 8. Benefits of Docker and Containerization

- **Portability:** Run your application anywhere Docker is supported.
- **Isolation:** Each container runs independently and securely.
- **Resource Efficiency:** Containers are lightweight and use fewer resources than virtual machines.
- **Consistency:** Applications run uniformly regardless of the environment.
- **Scalability:** Easily scale up or down by adding/removing containers.

---

## 9. Real-Life Scenarios for Containers

- **Microservices:** Deploying applications as a set of small, independent services.
- **CI/CD Pipelines:** Isolated, reproducible build and test environments.
- **Dev/Test Environments:** Quickly spin up environments for development and testing.
- **Cloud Deployments:** Consistent app deployment across different cloud providers.
- **Legacy App Modernization:** Containerizing old apps for easier migration and scaling.

---

## 10. Hands-on: Create, Build, and Run a Docker Container

### Step 1: Create a Python Script

Create a file named `hello.py`:
```python
print("Hello from inside the Docker container!")
```

### Step 2: Create a Dockerfile

```Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY hello.py .
CMD ["python", "hello.py"]
```

### Step 3: Build the Docker Image

```bash
docker build -t hello-docker .
```
- `-t hello-docker`: Tags the image with the name "hello-docker".
- `.`: Dot means current directory (Dockerfile location).

### Step 4: Run the Docker Container

```bash
docker run --name my-hello-container hello-docker
```
- `--name my-hello-container`: Names the running container.
- `hello-docker`: The image to run.

### Step 5: View Running Containers

```bash
docker ps
```

### Step 6: List All Containers (Including Stopped)

```bash
docker ps -a
```

### Step 7: Remove the Container

```bash
docker rm my-hello-container
```

---

## 11. Push Docker Image to Docker Hub

### Step 1: Create a Docker Hub Account
- Go to [Docker Hub](https://hub.docker.com/) and create a free account.

### Step 2: Login to Docker Hub from CLI
```bash
docker login
```
- Enter your Docker Hub username and password when prompted.

### Step 3: Tag Your Image for Docker Hub

Docker images are named as `username/repository:tag` for Docker Hub.

```bash
docker tag hello-docker yourdockerhubusername/hello-docker:latest
```

### Step 4: Push the Image to Docker Hub

```bash
docker push yourdockerhubusername/hello-docker:latest
```
- Replace `yourdockerhubusername` with your actual Docker Hub username.

### Step 5: Verify on Docker Hub

Go to your Docker Hub dashboard and check for the `hello-docker` repository. You should see your image listed.

---

## 12. Pull Docker Image from Docker Hub

### Step 1: Pull the Image

```bash
docker pull yourdockerhubusername/hello-docker:latest
```

### Step 2: Run a Container from the Pulled Image

```bash
docker run --name test-hello-container yourdockerhubusername/hello-docker:latest
```

---

## 13. Summary Table

| Concept                | Command/Example                                | Explanation                                            |
|------------------------|------------------------------------------------|--------------------------------------------------------|
| Docker Version         | `docker --version`                             | Check installed Docker version                         |
| Build Image            | `docker build -t <name> .`                     | Build Docker image from Dockerfile                     |
| Run Container          | `docker run --name <cname> <image>`            | Start a new container from an image                    |
| List Running Containers| `docker ps`                                    | Show active containers                                 |
| List All Containers    | `docker ps -a`                                 | Show all containers (active + stopped)                 |
| Remove Container       | `docker rm <cname>`                            | Delete a stopped container                             |
| Docker Login           | `docker login`                                 | Authenticate with Docker Hub                           |
| Tag Image              | `docker tag <src> <username>/<repo>:<tag>`     | Tag image for Docker Hub                               |
| Push Image             | `docker push <username>/<repo>:<tag>`          | Upload image to Docker Hub                             |
| Pull Image             | `docker pull <username>/<repo>:<tag>`          | Download image from Docker Hub                         |

---

**Congratulations, you've learned the basics of Docker, containerization, Docker registries, and how to push and pull images using Docker Hub!**

```bash
NOTE: To learn more explore the other commands one by one and use them

docker --help

Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Common Commands:
  run         Create and run a new container from an image
  exec        Execute a command in a running container
  ps          List containers
  build       Build an image from a Dockerfile
  pull        Download an image from a registry
  push        Upload an image to a registry
  images      List images
  login       Log in to a registry
  logout      Log out from a registry
  search      Search Docker Hub for images
  version     Show the Docker version information
  info        Display system-wide information

Management Commands:
  builder     Manage builds
  buildx*     Docker Buildx
  compose*    Docker Compose
  container   Manage containers
  context     Manage contexts
  image       Manage images
  manifest    Manage Docker image manifests and manifest lists
  network     Manage networks
  plugin      Manage plugins
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Swarm Commands:
  swarm       Manage Swarm

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  import      Import the contents from a tarball to create a filesystem image
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  wait        Block until one or more containers stop, then print their exit codes

Global Options:
      --config string      Location of client config files (default "/Users/aman.sharma/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set
                           with "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket to connect to
  -l, --log-level string   Set the logging level ("debug", "info", "warn", "error", "fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/Users/aman.sharma/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/Users/aman.sharma/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/Users/aman.sharma/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Run 'docker COMMAND --help' for more information on a command.

For more help on how to use Docker, head to https://docs.docker.com/go/guides/
```
