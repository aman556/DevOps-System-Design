# Creating a Web App Using Golang and Containerizing with Docker

This guide provides a comprehensive, hands-on lab to build a simple web application using Golang and then containerize it using Docker. You will learn to set up Go, write a basic HTTP handler, serve a web page that displays “DevOps System Design” on every GET request, and package the application into a Docker container for easy deployment.

## Table of Contents

- [Lab Overview](#lab-overview)
- [Project Structure](#project-structure)
- [Step-by-Step Instructions](#step-by-step-instructions)
- [Containerizing with Docker](#containerizing-with-docker)
- [Best Practices](#best-practices)
- [Resources](#resources)

---

## Lab Overview

| Section       | Details                                                                                      |
|---------------|---------------------------------------------------------------------------------------------|
| Objective     | Build a Golang web server, then containerize it with Docker                                  |
| Prerequisites | Command line basics, Docker, and internet access                                            |
| Tools Used    | Golang CLI, Docker                                                                          |
| Outcome       | A running HTTP server inside a Docker container                                             |

---

## Project Structure

| File/Folder  | Purpose                                               |
|--------------|-------------------------------------------------------|
| main.go      | Main application file with HTTP server implementation |
| Dockerfile   | Instructions to build the container image             |

---

## Step-by-Step Instructions

### 1. Install Golang CLI

| Step | Command/Link                                                                                 | Description                                 |
|------|---------------------------------------------------------------------------------------------|---------------------------------------------|
| 1    | [Download Go](https://go.dev/dl/)                                                           | Download Golang installer for your OS        |
| 2    | Follow installation steps on [Getting Started](https://go.dev/doc/install)                   | Install and verify Go with `go version`      |

### 2. Create Project Directory and Files

```bash
mkdir go-web-lab && cd go-web-lab
nano main.go
```

### 3. Add Golang Application Code

Paste the following code into `main.go`:

```go
package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "DevOps System Design")
}

func main() {
	http.HandleFunc("/", handler)
	port := ":8080"
	fmt.Printf("Server starting at http://localhost%s\n", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		fmt.Println("Server failed:", err)
	}
}
```

### 4. Run the Application Locally

```bash
go run main.go
```

Open your browser and visit: [http://localhost:8080](http://localhost:8080)  
You should see:  
```
DevOps System Design
```

---

## Containerizing with Docker

### 1. Create a Dockerfile

Create a file named `Dockerfile` in your project directory.

#### Dockerfile line-by-line instructions:

| Line(s)                                   | Command/Instruction                                  | Description                                                   |
|-------------------------------------------|------------------------------------------------------|---------------------------------------------------------------|
| 1                                         | `FROM golang:1.22-alpine AS builder`                 | Use a lightweight Go image for building the binary            |
| 2                                         | `WORKDIR /app`                                       | Set working directory inside the container                    |
| 3                                         | `COPY main.go .`                                     | Copy your Go source code into the container                   |
| 4                                         | `RUN go build -o app main.go`                        | Build the Go binary inside the container                      |
| 5                                         | `FROM alpine:latest`                                 | Use a minimal base image for the final container              |
| 6                                         | `WORKDIR /root/`                                     | Set working directory for runtime                             |
| 7                                         | `COPY --from=builder /app/app .`                     | Copy the built binary from the builder stage                  |
| 8                                         | `EXPOSE 8080`                                        | Expose port 8080                                              |
| 9                                         | `CMD ["./app"]`                                      | Run the binary when the container starts                      |

**Complete Dockerfile:**

```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o app main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]
```

---

### 2. Build the Docker Image

```bash
docker build -t devops-system-design:latest .
```
- `-t devops-system-design:latest` tags your image for easy reference.
- `.` tells Docker to use the Dockerfile in the current directory.

### 3. Run the Docker Container

```bash
docker run -d -p 8080:8080 --name devops-system-design devops-system-design:latest
```
- `-d` runs the container in detached mode.
- `-p 8080:8080` maps container port 8080 to host port 8080.
- `--name devops-system-design` names your container for easy management.

### 4. Test the Application

Open your browser and visit: [http://localhost:8080](http://localhost:8080)  
You should see:  
```
DevOps System Design
```

---

## Best Practices

| Practice                | Description                                                                 |
|-------------------------|-----------------------------------------------------------------------------|
| Multi-stage Builds      | Keeps final image small and secure by only copying the binary               |
| Minimal Base Image      | Use Alpine or scratch images to reduce attack surface and size              |
| Expose Necessary Ports  | Only expose required ports (here, 8080)                                     |
| Avoid Root User         | For production, add a non-root user and run the app as that user            |
| Version Pinning         | Pin Go and base image versions for reproducible builds                      |

---

## Resources

| Resource Name               | Link/Reference                                |
|-----------------------------|-----------------------------------------------|
| Go Official Documentation   | https://go.dev/doc/                          |
| Docker Official Docs        | https://docs.docker.com/                      |
| Go net/http Package Docs    | https://pkg.go.dev/net/http                   |
| Go by Example: HTTP Servers | https://gobyexample.com/http-servers          |
| Dockerfile Best Practices   | https://docs.docker.com/develop/develop-images/dockerfile_best-practices/ |
