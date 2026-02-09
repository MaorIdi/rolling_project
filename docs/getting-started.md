---
layout: default
title: Getting Started
nav_order: 2
description: "Complete beginner's guide to setting up the AWS Resource Dashboard"
permalink: /getting-started/
---

# Getting Started

{: .fs-9 }

A complete step-by-step guide to set up everything you need to run this project.
{: .fs-6 .fw-300 }

---

## Table of Contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

---

## Prerequisites Checklist

Before you begin, make sure you have the following installed on your computer:

| Requirement | Minimum Version | How to Check          | Download Link                                      |
| :---------- | :-------------- | :-------------------- | :------------------------------------------------- |
| Python      | 3.7+            | `python --version`    | [python.org](https://www.python.org/downloads/)    |
| pip         | Latest          | `pip --version`       | Comes with Python                                  |
| Docker      | 20.10+          | `docker --version`    | [docker.com](https://docs.docker.com/get-docker/)  |
| Git         | Any             | `git --version`       | [git-scm.com](https://git-scm.com/downloads)       |
| AWS CLI     | 2.0+            | `aws --version`       | [AWS CLI](https://aws.amazon.com/cli/)             |
| Terraform   | 1.0+            | `terraform --version` | [terraform.io](https://www.terraform.io/downloads) |

{: .note }

> **Don't have all of these?** That's okay! You only need Python to run the app locally. Docker and Terraform are optional for advanced deployment.

---

## Step 1: Install Python

Python is the programming language this application is written in.

### Windows

1. Download Python from [python.org](https://www.python.org/downloads/)
2. Run the installer
3. **IMPORTANT**: Check ✅ "Add Python to PATH" during installation
4. Click "Install Now"

### macOS

```bash
# Using Homebrew (recommended)
brew install python

# Or download from python.org
```

### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install python3 python3-pip
```

### Verify Installation

Open a terminal and run:

```bash
python --version
# Should show: Python 3.11.x (or similar)

pip --version
# Should show: pip 23.x.x (or similar)
```

{: .highlight }

> **Python vs Python3**: On some systems, you might need to use `python3` and `pip3` instead of `python` and `pip`.

---

## Step 2: Install Docker

Docker lets you run applications in isolated containers. Think of it like a lightweight virtual machine.

### Windows/macOS

1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Run the installer
3. Restart your computer if prompted
4. Open Docker Desktop and wait for it to start

### Linux (Ubuntu)

```bash
# Remove old versions (if any)
sudo apt remove docker docker-engine docker.io containerd runc

# Install Docker
curl -fsSL https://get.docker.com | sudo sh

# Add your user to the docker group (so you don't need sudo)
sudo usermod -aG docker $USER

# Log out and back in for this to take effect
```

### Verify Installation

```bash
docker --version
# Should show: Docker version 24.x.x

docker run hello-world
# Should download and run a test container
```

{: .important }

> **Docker Desktop License**: Docker Desktop is free for personal use and education. For commercial use, check their [pricing page](https://www.docker.com/pricing/).

---

## Step 3: Create an AWS Account

If you don't have an AWS account yet:

1. Go to [aws.amazon.com](https://aws.amazon.com/)
2. Click "Create an AWS Account"
3. Follow the registration process
4. You'll need a credit card, but you can use the [Free Tier](https://aws.amazon.com/free/)

{: .warning }

> **Cost Warning**: While AWS has a free tier, some resources can incur charges. Always clean up resources when you're done experimenting!

---

## Step 4: Create AWS Access Keys

The application needs credentials to read your AWS resources.

### Step 4.1: Create an IAM User

1. Log into [AWS Console](https://console.aws.amazon.com/)
2. Search for "IAM" in the search bar
3. Click "Users" in the left sidebar
4. Click "Add users" button

### Step 4.2: Configure the User

1. **User name**: `aws-dashboard-reader` (or any name you like)
2. Click "Next"

### Step 4.3: Set Permissions

1. Select "Attach policies directly"
2. Search for and check these policies:
   - `AmazonEC2ReadOnlyAccess`
   - `ElasticLoadBalancingReadOnly`
3. Click "Next", then "Create user"

{: .note }

> **Why ReadOnly?** This application only reads data. Using read-only permissions follows the "principle of least privilege" - only give the permissions that are needed.

### Step 4.4: Create Access Keys

1. Click on your new user
2. Go to the "Security credentials" tab
3. Scroll to "Access keys"
4. Click "Create access key"
5. Select "Command Line Interface (CLI)"
6. Check the confirmation box
7. Click "Next", then "Create access key"

### Step 4.5: Save Your Keys

You'll see two values:

- **Access key ID**: Looks like `AKIAIOSFODNN7EXAMPLE`
- **Secret access key**: Looks like `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`

{: .warning }

> **Save these now!** The secret key is only shown once. Store them securely (not in code!).

---

## Step 5: Configure AWS Credentials

Now let's set up your credentials so the application can use them.

### Option A: Environment Variables (Recommended for Development)

Set these in your terminal:

**Windows (Command Prompt)**

```cmd
set AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
set AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
set AWS_REGION=us-east-1
```

**Windows (PowerShell)**

```powershell
$env:AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
$env:AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$env:AWS_REGION="us-east-1"
```

**Linux/macOS**

```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_REGION="us-east-1"
```

### Option B: AWS CLI Configuration (Recommended for Long-term Use)

```bash
aws configure
```

You'll be prompted for:

```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

This saves your credentials to `~/.aws/credentials` (safe and reusable).

### Verify Your Configuration

```bash
aws sts get-caller-identity
```

Should output something like:

```json
{
  "UserId": "AIDAEXAMPLEUSERID",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/aws-dashboard-reader"
}
```

---

## Step 6: Clone the Repository

Now let's download the project code.

```bash
# Navigate to where you want to store the project
cd ~/projects  # or wherever you keep code

# Clone the repository
git clone https://github.com/MaorIdi/rolling_project.git

# Navigate into the project
cd rolling_project

# See what files are there
ls -la
```

You should see:

```
Dockerfile
Jenkinsfile
README.md
aws/
docs/
python/
terraform/
```

---

## Step 7: Install Python Dependencies

The application needs some Python packages to work.

```bash
# Navigate to the python folder
cd python

# Install the required packages
pip install -r requirements.txt
```

### What Gets Installed?

| Package  | Version | Purpose                                  |
| :------- | :------ | :--------------------------------------- |
| Flask    | 3.1.2   | Web framework for building the dashboard |
| boto3    | 1.40.28 | AWS SDK - talks to AWS services          |
| Jinja2   | 3.1.6   | Template engine for HTML                 |
| Werkzeug | 3.1.3   | WSGI utilities (Flask dependency)        |

---

## Step 8: Run the Application

You're ready to start the application!

```bash
# Make sure you're in the python folder
cd python

# Make sure AWS credentials are set (see Step 5)

# Run the application
python app.py
```

You should see:

```
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://0.0.0.0:5001
```

### Open the Dashboard

1. Open your web browser
2. Go to: `http://localhost:5001`
3. You should see your AWS resources displayed!

{: .highlight }

> **No resources showing?** That's normal if your AWS account is empty. Try creating an EC2 instance in AWS Console and refresh the dashboard.

---

## Step 9: (Optional) Run with Docker

If you want to use Docker instead:

```bash
# Go back to the project root
cd ..

# Build the Docker image
docker build -t flask-aws-monitor .

# Run the container
docker run -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID="your-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret" \
  -e AWS_REGION="us-east-1" \
  flask-aws-monitor
```

Open `http://localhost:5001` in your browser.

---

## Understanding What Just Happened

Let's recap what you've set up:

```mermaid
flowchart LR
    A[Your Browser] -->|HTTP Request| B[Flask App]
    B -->|AWS SDK| C[AWS APIs]
    C -->|EC2 Data| D[(EC2)]
    C -->|VPC Data| E[(VPC)]
    C -->|LB Data| F[(ELB)]
    C -->|AMI Data| G[(AMI)]
    D --> B
    E --> B
    F --> B
    G --> B
    B -->|HTML Response| A
```

1. **Browser** → Sends request to your Flask app
2. **Flask App** → Uses Boto3 (AWS SDK) to query AWS
3. **AWS** → Returns information about your resources
4. **Flask App** → Formats data into HTML tables
5. **Browser** → Displays the dashboard

---

## Next Steps

Now that you have the basics running, explore these topics:

| Guide                             | What You'll Learn                       |
| :-------------------------------- | :-------------------------------------- |
| [Docker Guide](docker.html)       | Package the app for deployment anywhere |
| [Terraform Guide](terraform.html) | Create AWS infrastructure automatically |
| [Jenkins Guide](jenkins.html)     | Automate building and deployment        |

---

## Quick Reference

### AWS Regions

Common regions you might use:

| Region Code      | Location                                   |
| :--------------- | :----------------------------------------- |
| `us-east-1`      | N. Virginia (most services available here) |
| `us-west-2`      | Oregon                                     |
| `eu-west-1`      | Ireland                                    |
| `eu-central-1`   | Frankfurt                                  |
| `ap-southeast-1` | Singapore                                  |

### Useful Commands

```bash
# Check if credentials work
aws sts get-caller-identity

# List EC2 instances
aws ec2 describe-instances

# Check Docker is running
docker ps

# Stop the Flask app
Press Ctrl+C in the terminal
```

---

## Troubleshooting

Having issues? Check the [Troubleshooting Guide](troubleshooting.html) for solutions to common problems.
