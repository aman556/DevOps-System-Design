# Docker Lab Guide

This lab will introduce you to Docker and the fundamentals of containerization. You'll learn about key Docker concepts, important commands, and how to create and run a Docker container with hands-on steps.

**Things to keep in mind:**
1. Don't get overwhelmed by concepts and commands. It is hard for everyone in starting to understand these concepts at once.
2. Try installing the docker and running the commands yourself this will help in strong foundation.
---

## 1. What is Containerization?

**Containerization** is a technology that allows you to package and run applications and their dependencies in isolated environments called containers. Unlike virtual machines, containers share the host operating system's kernel but have their own filesystem, processes, and network stack. This ensures consistency across environments and makes applications portable and lightweight.

```
Case Study 1: Real Life
Imagine the global shipping industry. Goods are packed into standardized shipping containers that can be easily loaded onto ships, trains, and trucks. Regardless of what’s inside—a car, electronics, or food—the container’s format ensures it can be transported, managed, and stacked efficiently anywhere in the world. The shipping companies don’t need to know the contents; they just need to handle the containers.

Relating to Docker:
Just like shipping containers, Docker containers package up an application with everything it needs (code, runtime, dependencies, etc.), so it can be moved easily across environments—developer laptops, test servers, or production—regardless of underlying infrastructure.
```

```
Case Study 2: Real Industry Practice
Consider a modern e-commerce platform (like Amazon or Shopify). During high-traffic events (Black Friday sales), the platform needs to handle millions of visitors simultaneously. Using Docker, the company can package their web application and launch hundreds or thousands of identical containers across multiple servers (on-premises or in the cloud). Each container runs an isolated instance of the app, ensuring consistent performance and easy scaling. If one container fails, it can be replaced instantly without affecting the rest.

Relating to Docker:
This approach allows companies to rapidly scale up or down, roll out updates without downtime, and deploy the same application across different environments with confidence that it will work the same way everywhere.
```
---

## 2. Docker

**Docker** is the most popular platform used for containerization. It provides tools to build, ship, and run containers efficiently. Docker simplifies deploying applications by packaging everything needed to run them (code, libraries, system tools) into containers.

Note: Follow docker installation [documentation](https://docs.docker.com/get-started/get-docker/) to install it.

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

Note: In above example we have shown few commands used in Dockerfile. To learn more about all the commands you can refer [docker documentation](https://docs.docker.com/reference/dockerfile/) for Dockerfile commands.

---
## 5. Docker Image

A **Docker image** is a lightweight, standalone, and executable software package that includes everything needed to run a piece of software, including the code, runtime, libraries, and dependencies. Images are built from Dockerfiles.

*Build command:*
```bash
# build an Image from a Dockerfile
docker build -t <image_name> .

# build an Image from a Dockerfile without the cache
docker build -t <image_name> . –no-cache

# list local docker images
docker images

# delete an Image
docker rmi <image_name>

# remove all unused images
docker image prune
```

---

## 6. Docker Container

A **Docker container** is a runnable instance of a Docker image. Containers are isolated from each other and the host system, but they can communicate through defined channels.

*Run command:*
```bash
# create and run a container from an image, with a custom name:
docker run --name <container_name> <image_name>

# run a container with and publish a container’s port(s) to the host.
docker run -p <host_port>:<container_port> <image_name>

# run a container in the background
docker run -d <image_name>

# start or stop an existing container:
docker start|stop <container_name> (or <container-id>)

# remove a stopped container:
docker rm <container_name>

# open a shell inside a running container:
docker exec -it <container_name> sh

# fetch and follow the logs of a container:
docker logs -f <container_name>

# to inspect a running container:
docker inspect <container_name> (or <container_id>)

# to list currently running containers:
docker ps

# list all docker containers (running and stopped):
docker ps --all

# view resource usage stats
docker container stats
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

```bash
# login into Docker
docker login -u <username>

# publish an image to Docker Hub
docker push <username>/<image_name>

# search Hub for an image
docker search <image_name>

# pull an image from a Docker Hub
docker pull <image_name>
```

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
