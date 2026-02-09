---
layout: default
title: Docker Guide
nav_order: 3
description: "Learn how to use Docker to containerize and deploy the AWS Resource Dashboard"
permalink: /docker/
---

# Docker Guide

{: .fs-9 }

Learn how to containerize and deploy the application using Docker.
{: .fs-6 .fw-300 }

---

## Table of Contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

---

## What is Docker?

Docker is a platform that packages applications into **containers** - lightweight, standalone packages that include everything needed to run the application.

### Why Use Docker?

| Benefit         | Explanation                                    |
| :-------------- | :--------------------------------------------- |
| **Consistency** | Runs the same on your laptop, server, or cloud |
| **Isolation**   | Each container runs independently              |
| **Portability** | Once built, runs anywhere Docker is installed  |
| **Simplicity**  | No need to install Python, dependencies, etc.  |

{: .highlight }

> **Think of it like this**: A container is like a shipping container. Everything is packaged inside, and it works the same whether it's on a truck, ship, or train.

---

## Docker Concepts for Beginners

Before we dive in, let's understand some key terms:

### Image vs Container

```mermaid
flowchart LR
    A[Dockerfile] -->|docker build| B[Image]
    B -->|docker run| C[Container 1]
    B -->|docker run| D[Container 2]
    B -->|docker run| E[Container 3]
```

| Term           | What It Is                          | Analogy         |
| :------------- | :---------------------------------- | :-------------- |
| **Dockerfile** | Instructions to build an image      | A recipe        |
| **Image**      | A template/blueprint for containers | A cake mold     |
| **Container**  | A running instance of an image      | The actual cake |

### Docker Hub

[Docker Hub](https://hub.docker.com/) is like GitHub but for Docker images. You can:

- Pull images others have created
- Push your own images
- Share images with your team

---

## Understanding Our Dockerfile

Let's look at the project's Dockerfile line by line:

```dockerfile
# Start from an official Python image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file first (for caching)
COPY python/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY python/ .

# Tell Docker which port our app uses
EXPOSE 5001

# Set an environment variable
ENV FLASK_APP=app.py

# Command to run when container starts
CMD ["python", "app.py"]
```

### Line-by-Line Explanation

#### `FROM python:3.11-slim`

{: .no_toc }

This tells Docker to start from a base image that already has Python 3.11 installed.

- `python:3.11-slim` is a lightweight version (smaller download)
- The `slim` variant doesn't include extra tools we don't need

#### `WORKDIR /app`

{: .no_toc }

Creates and sets `/app` as the current directory inside the container. All following commands will run from here.

#### `COPY python/requirements.txt .`

{: .no_toc }

Copies `requirements.txt` from your computer into the container.

{: .note }

> **Why copy this first?** Docker caches each layer. By copying requirements first, Docker can reuse the cached dependencies if only your code changes (not dependencies).

#### `RUN pip install --no-cache-dir -r requirements.txt`

{: .no_toc }

Installs all Python packages listed in requirements.txt.

- `--no-cache-dir` saves space by not caching pip downloads

#### `COPY python/ .`

{: .no_toc }

Copies your application code into the container.

#### `EXPOSE 5001`

{: .no_toc }

Documents that the container listens on port 5001. This doesn't actually publish the port - that's done with `-p` when running.

#### `ENV FLASK_APP=app.py`

{: .no_toc }

Sets an environment variable. Flask uses this to know which file is the main application.

#### `CMD ["python", "app.py"]`

{: .no_toc }

The command that runs when the container starts. This starts our Flask application.

---

## Building the Docker Image

### Step 1: Navigate to Project Root

```bash
cd /path/to/rolling_project
```

Make sure you're in the folder that contains the `Dockerfile`.

### Step 2: Build the Image

```bash
docker build -t flask-aws-monitor .
```

**What this means:**

- `docker build` - Command to build an image
- `-t flask-aws-monitor` - Tag (name) for the image
- `.` - Build context (current directory)

### What Happens During Build

You'll see output like this:

```
[+] Building 45.2s (10/10) FINISHED
 => [1/5] FROM python:3.11-slim
 => [2/5] WORKDIR /app
 => [3/5] COPY python/requirements.txt .
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt
 => [5/5] COPY python/ .
 => exporting to image
 => naming to docker.io/library/flask-aws-monitor
```

### Verify the Image Was Created

```bash
docker images
```

Output:

```
REPOSITORY           TAG       IMAGE ID       CREATED          SIZE
flask-aws-monitor    latest    abc123def456   10 seconds ago   180MB
```

---

## Running the Container

### Basic Run Command

```bash
docker run -d -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID="your-access-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret-key" \
  -e AWS_REGION="us-east-1" \
  flask-aws-monitor
```

### Command Breakdown

| Part                | Meaning                                         |
| :------------------ | :---------------------------------------------- |
| `docker run`        | Create and start a container                    |
| `-d`                | Detached mode (run in background)               |
| `-p 5001:5001`      | Map port 5001 on host to port 5001 in container |
| `-e VAR=value`      | Set environment variables                       |
| `flask-aws-monitor` | Image name to use                               |

### Understanding Port Mapping

```
-p HOST_PORT:CONTAINER_PORT
-p 5001:5001
```

```mermaid
flowchart LR
    A[Your Browser<br>localhost:5001] -->|Port 5001| B[Docker Host]
    B -->|Port 5001| C[Container<br>Flask App]
```

- The left number is the port on YOUR computer
- The right number is the port inside the container
- They don't have to match! `-p 8080:5001` would work too

---

## Managing Containers

### View Running Containers

```bash
docker ps
```

Output:

```
CONTAINER ID   IMAGE               STATUS          PORTS                    NAMES
a1b2c3d4e5f6   flask-aws-monitor   Up 5 minutes    0.0.0.0:5001->5001/tcp   happy_einstein
```

### View All Containers (Including Stopped)

```bash
docker ps -a
```

### View Container Logs

```bash
# Using container ID
docker logs a1b2c3d4e5f6

# Using container name
docker logs happy_einstein

# Follow logs in real-time
docker logs -f happy_einstein
```

### Stop a Container

```bash
# Using container ID
docker stop a1b2c3d4e5f6

# Using container name
docker stop happy_einstein
```

### Remove a Container

```bash
# Stop first, then remove
docker stop happy_einstein
docker rm happy_einstein

# Force remove (even if running)
docker rm -f happy_einstein
```

### Remove the Image

```bash
docker rmi flask-aws-monitor
```

---

## Using Docker Hub

### What is Docker Hub?

Docker Hub is a cloud registry where you can store and share Docker images.

Our image is published at: `maoridi/rolling-project`

### Pull from Docker Hub

```bash
docker pull maoridi/rolling-project:latest
```

### Run from Docker Hub

```bash
docker run -d -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID="your-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret" \
  -e AWS_REGION="us-east-1" \
  maoridi/rolling-project:latest
```

### Push Your Own Image

If you make changes and want to push to Docker Hub:

```bash
# Login to Docker Hub
docker login

# Tag your image with your username
docker tag flask-aws-monitor yourusername/flask-aws-monitor:latest

# Push to Docker Hub
docker push yourusername/flask-aws-monitor:latest
```

---

## Docker Compose (Optional)

For more complex setups, Docker Compose lets you define multiple containers in a YAML file.

### Create docker-compose.yml

```yaml
version: "3.8"

services:
  aws-dashboard:
    build: .
    ports:
      - "5001:5001"
    environment:
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_REGION=${AWS_REGION}
    restart: unless-stopped
```

### Run with Docker Compose

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## Best Practices

### 1. Don't Store Credentials in Images

{: .warning }

> **Never put AWS credentials in your Dockerfile!** Always pass them as environment variables at runtime.

❌ **Bad:**

```dockerfile
ENV AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
```

✅ **Good:**

```bash
docker run -e AWS_ACCESS_KEY_ID="..." myimage
```

### 2. Use .dockerignore

Create a `.dockerignore` file to exclude files from the build:

```
# .dockerignore
.git
.gitignore
__pycache__
*.pyc
.env
.venv
terraform/
docs/
*.md
```

### 3. Use Specific Tags

Instead of `latest`, use version tags:

```bash
docker build -t flask-aws-monitor:1.0.0 .
docker build -t flask-aws-monitor:1.0.1 .
```

### 4. Keep Images Small

- Use `slim` or `alpine` base images
- Remove cache after installing packages
- Don't install unnecessary tools

---

## Common Docker Commands Cheat Sheet

| Command                             | Description               |
| :---------------------------------- | :------------------------ |
| `docker build -t name .`            | Build an image            |
| `docker run -d -p 5001:5001 name`   | Run a container           |
| `docker ps`                         | List running containers   |
| `docker ps -a`                      | List all containers       |
| `docker logs container_id`          | View container logs       |
| `docker stop container_id`          | Stop a container          |
| `docker rm container_id`            | Remove a container        |
| `docker images`                     | List images               |
| `docker rmi image_name`             | Remove an image           |
| `docker exec -it container_id bash` | Shell into container      |
| `docker system prune`               | Clean up unused resources |

---

## Troubleshooting Docker Issues

### Container Exits Immediately

Check the logs:

```bash
docker logs container_id
```

Common causes:

- Missing environment variables
- Application crash
- Wrong command

### Port Already in Use

```
Error: port 5001 is already allocated
```

Solution:

```bash
# Find what's using the port
lsof -i :5001  # Linux/Mac
netstat -ano | findstr :5001  # Windows

# Use a different host port
docker run -p 5002:5001 ...
```

### Permission Denied

```bash
# Add yourself to docker group (Linux)
sudo usermod -aG docker $USER

# Log out and back in
```

### Image Not Found

Make sure you've built the image:

```bash
docker build -t flask-aws-monitor .
```

---

## Next Steps

Now that you understand Docker, learn about:

- [Terraform Guide](terraform.html) - Provision AWS infrastructure
- [Jenkins Guide](jenkins.html) - Automate Docker builds with CI/CD
