---
layout: default
title: Troubleshooting
nav_order: 6
description: "Solutions to common problems and errors"
permalink: /troubleshooting/
---

# Troubleshooting Guide

{: .fs-9 }

Solutions to common problems you might encounter.
{: .fs-6 .fw-300 }

---

## Table of Contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

---

## Quick Diagnostic Commands

Run these commands to quickly identify issues:

```bash
# Check Python version
python --version

# Check if AWS credentials are set
aws sts get-caller-identity

# Check Docker is running
docker ps

# Check Terraform version
terraform --version

# Test network connectivity
curl -I https://aws.amazon.com
```

---

## AWS Credential Issues

### Error: "Unable to locate credentials"

```
botocore.exceptions.NoCredentialsError: Unable to locate credentials
```

**Cause:** AWS credentials are not configured.

**Solution 1: Set Environment Variables**

```bash
# Linux/Mac
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_REGION="us-east-1"

# Windows (PowerShell)
$env:AWS_ACCESS_KEY_ID="your-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret"
$env:AWS_REGION="us-east-1"

# Windows (CMD)
set AWS_ACCESS_KEY_ID=your-key
set AWS_SECRET_ACCESS_KEY=your-secret
set AWS_REGION=us-east-1
```

**Solution 2: Use AWS CLI Configure**

```bash
aws configure
# Enter your credentials when prompted
```

**Solution 3: Check Existing Credentials**

```bash
# View credentials file
cat ~/.aws/credentials  # Linux/Mac
type %USERPROFILE%\.aws\credentials  # Windows
```

---

### Error: "InvalidAccessKeyId"

```
botocore.exceptions.ClientError: An error occurred (InvalidAccessKeyId)
```

**Cause:** The access key ID is incorrect or doesn't exist.

**Solution:**

1. Go to AWS Console → IAM → Users → Your User
2. Go to Security credentials tab
3. Create new access keys
4. Update your credentials

---

### Error: "SignatureDoesNotMatch"

```
botocore.exceptions.ClientError: An error occurred (SignatureDoesNotMatch)
```

**Cause:** The secret access key is incorrect.

**Solution:**

1. Create a new access key pair in AWS Console
2. Update both the access key ID and secret key

---

### Error: "AccessDenied"

```
botocore.exceptions.ClientError: An error occurred (AccessDenied) when calling the DescribeInstances operation
```

**Cause:** Your IAM user doesn't have the required permissions.

**Solution:** Attach these policies to your IAM user:

- `AmazonEC2ReadOnlyAccess`
- `ElasticLoadBalancingReadOnly`

Or create a custom policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeVpcs",
        "ec2:DescribeImages",
        "elbv2:DescribeLoadBalancers"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Python Issues

### Error: "ModuleNotFoundError: No module named 'flask'"

```
ModuleNotFoundError: No module named 'flask'
```

**Cause:** Python dependencies are not installed.

**Solution:**

```bash
cd python
pip install -r requirements.txt
```

---

### Error: "python: command not found"

**Cause:** Python is not installed or not in PATH.

**Solution 1: Try `python3` instead**

```bash
python3 app.py
```

**Solution 2: Install Python**

- Windows: Download from [python.org](https://python.org) and check "Add to PATH"
- Mac: `brew install python`
- Linux: `sudo apt install python3 python3-pip`

---

### Error: "pip: command not found"

**Solution 1: Try `pip3`**

```bash
pip3 install -r requirements.txt
```

**Solution 2: Use Python module**

```bash
python -m pip install -r requirements.txt
```

---

### Error: "Address already in use"

```
OSError: [Errno 98] Address already in use
```

**Cause:** Port 5001 is already being used by another application.

**Solution 1: Find and stop the process**

```bash
# Linux/Mac
lsof -i :5001
kill -9 <PID>

# Windows
netstat -ano | findstr :5001
taskkill /PID <PID> /F
```

**Solution 2: Use a different port**

```python
# In app.py, change:
app.run(host="0.0.0.0", port=5002, debug=True)
```

---

## Docker Issues

### Error: "Cannot connect to the Docker daemon"

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Cause:** Docker service is not running.

**Solution:**

```bash
# Linux
sudo systemctl start docker
sudo systemctl enable docker

# Mac/Windows
# Open Docker Desktop application
```

---

### Error: "permission denied while trying to connect to Docker"

```
Got permission denied while trying to connect to the Docker daemon socket
```

**Cause:** Current user doesn't have permission to use Docker.

**Solution (Linux):**

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and log back in, or run:
newgrp docker
```

---

### Error: "port is already allocated"

```
Error: port 5001 is already allocated
```

**Cause:** Another container or process is using port 5001.

**Solution 1: Stop the other container**

```bash
docker ps  # Find the container using the port
docker stop <container_id>
```

**Solution 2: Use a different port**

```bash
docker run -p 5002:5001 flask-aws-monitor
# Access at http://localhost:5002
```

---

### Error: "image not found"

```
Unable to find image 'flask-aws-monitor:latest' locally
```

**Cause:** The Docker image hasn't been built yet.

**Solution:**

```bash
# Make sure you're in the project root (where Dockerfile is)
docker build -t flask-aws-monitor .
```

---

### Error: Docker build fails at pip install

```
ERROR: Could not find a version that satisfies the requirement
```

**Cause:** Network issues or invalid package name.

**Solution 1: Check network**

```bash
# Test network inside container
docker run --rm python:3.11-slim pip install flask
```

**Solution 2: Check requirements.txt formatting**

```bash
# Make sure no Windows line endings
dos2unix python/requirements.txt
```

---

## Terraform Issues

### Error: "No valid credential sources found"

```
Error: No valid credential sources found
```

**Cause:** Terraform can't find AWS credentials.

**Solution:**

```bash
# Option 1: Use AWS CLI
aws configure

# Option 2: Set environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

---

### Error: "VPC not found" or "Subnet not found"

```
Error: Error creating Security Group: VpcIdNotSpecified
```

**Cause:** The VPC ID or Subnet ID in variables.tf doesn't exist in your account.

**Solution:**

1. Go to AWS Console → VPC
2. Find your VPC ID (starts with `vpc-`)
3. Find your Subnet ID (starts with `subnet-`)
4. Update `terraform/variables.tf`:

```hcl
variable "vpc_id" {
  default = "vpc-your-actual-vpc-id"
}

variable "public_subnet_id" {
  default = "subnet-your-actual-subnet-id"
}
```

---

### Error: "AMI not found"

```
Error: InvalidAMIID.NotFound
```

**Cause:** The AMI ID doesn't exist in your region.

**Solution:**

1. Go to AWS Console → EC2 → AMIs
2. Search for "Amazon Linux 2"
3. Copy the AMI ID
4. Update `terraform/variables.tf`:

```hcl
variable "ami_id" {
  default = "ami-your-region-ami-id"
}
```

---

### Error: "Error acquiring state lock"

```
Error: Error acquiring the state lock
```

**Cause:** Another Terraform process is running, or a previous run crashed.

**Solution:**

```bash
# Force unlock (use with caution!)
terraform force-unlock LOCK_ID
```

---

### Error: "terraform: command not found"

**Cause:** Terraform is not installed or not in PATH.

**Solution:**

```bash
# Mac
brew install terraform

# Windows (Chocolatey)
choco install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

---

## Jenkins Issues

### Error: "Jenkins cannot access Docker"

```
Cannot run program "docker": error=2, No such file or directory
```

**Cause:** Docker not installed or Jenkins user can't access it.

**Solution:**

```bash
# Install Docker
sudo yum install docker -y
sudo systemctl start docker

# Add Jenkins to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

### Error: "Credentials not found"

```
CredentialNotFoundException: dockerhub-username
```

**Cause:** Credentials not configured in Jenkins.

**Solution:**

1. Go to Jenkins → Manage Jenkins → Credentials
2. Add credentials with exact IDs:
   - `dockerhub-username`
   - `dockerhub-password`

---

### Error: "Permission denied" during Docker push

```
denied: requested access to the resource is denied
```

**Cause:** Docker Hub credentials are incorrect or you don't have push access.

**Solution:**

1. Verify Docker Hub credentials
2. Make sure you're pushing to your own repository
3. Use Docker Hub access token instead of password

---

### Error: Jenkins UI not accessible

**Cause:** Security group doesn't allow port 8080.

**Solution:**

1. Go to AWS Console → EC2 → Security Groups
2. Edit the security group attached to your instance
3. Add inbound rule:
   - Type: Custom TCP
   - Port: 8080
   - Source: Your IP

---

## Network Issues

### Error: "Connection timed out"

**Cause:** Network connectivity issues or firewall blocking.

**Solution:**

1. Check if you can reach AWS:

```bash
curl -I https://ec2.amazonaws.com
```

2. Check if VPN/proxy is interfering

3. Check security group allows outbound traffic

---

### Error: Cannot access application at localhost:5001

**Cause:** Application not running or wrong port.

**Solution:**

1. Verify application is running:

```bash
# For Python
ps aux | grep python

# For Docker
docker ps
```

2. Check application logs for errors

3. Try accessing http://127.0.0.1:5001 instead

---

## Application Shows No Data

### Dashboard shows empty tables

**Cause 1:** No resources exist in your AWS account.

**Solution:** Create test resources:

```bash
# Create a test EC2 instance via AWS Console
# Or use Terraform to create resources
```

**Cause 2:** AWS credentials don't have permissions.

**Solution:** Check IAM permissions (see AWS Credential Issues).

**Cause 3:** Wrong AWS region.

**Solution:** Set the correct region:

```bash
export AWS_REGION="us-east-1"  # Change to your region
```

---

## Getting More Help

### Useful Diagnostic Information

When asking for help, include:

```bash
# System info
uname -a  # Linux/Mac
systeminfo  # Windows

# Python version
python --version

# Docker version
docker --version

# Terraform version
terraform --version

# AWS CLI version
aws --version

# Error message (full output)
# What you were trying to do
# What you expected to happen
```

### Resources

- [AWS Documentation](https://docs.aws.amazon.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)

### Still Stuck?

1. Search the error message on Google
2. Check Stack Overflow
3. Open an issue on the [GitHub repository](https://github.com/MaorIdi/rolling_project/issues)
