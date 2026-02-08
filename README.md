# AWS Resource Dashboard

A Flask-based web application that provides a real-time dashboard for viewing AWS resources in your account. The application displays EC2 instances, VPCs, Load Balancers, and AMIs in an organized, easy-to-read format.

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://python.org)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-purple.svg)](https://terraform.io)
[![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-red.svg)](https://jenkins.io)

📖 **[View Full Documentation](https://maoridi.github.io/rolling_project/)**

## 🚀 Features

- **EC2 Instances**: View instance ID, state, type, and public IP address
- **VPC Information**: Display VPC IDs and their CIDR blocks
- **Load Balancers**: Show load balancer names and DNS names
- **AMI Images**: List custom AMIs owned by your account
- **Real-time Data**: Fetches live data directly from AWS APIs
- **Clean UI**: Simple, responsive web interface with organized tables

## 📋 Prerequisites

- Python 3.7 or higher
- Docker (for containerized deployment)
- AWS Account with appropriate permissions
- Terraform (for infrastructure provisioning)
- Jenkins (for CI/CD pipeline)

## 🛠️ Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/MaorIdi/rolling_project.git
   cd rolling_project
   ```

2. **Navigate to the Python directory**

   ```bash
   cd python
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

## ⚙️ Configuration

### AWS Credentials Setup

You need to configure AWS credentials using environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_REGION="us-east-1"
```

### Required AWS Permissions

Your AWS user/role must have the following permissions:

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

## 🏃‍♂️ Running the Application

### Option 1: Run Locally

```bash
cd python
python app.py
```

Access the dashboard at: `http://localhost:5001`

### Option 2: Run with Docker

```bash
# Build the image
docker build -t flask-aws-monitor .

# Run the container
docker run -d -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID="your-access-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret-key" \
  -e AWS_REGION="us-east-1" \
  flask-aws-monitor
```

### Option 3: Use Pre-built Docker Hub Image

```bash
docker run -d -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID="your-access-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret-key" \
  -e AWS_REGION="us-east-1" \
  maoridi/rolling-project:latest
```

## 🐳 Docker

The application is containerized for easy deployment:

```bash
# Build locally
docker build -t flask-aws-monitor .

# Or pull from Docker Hub
docker pull maoridi/rolling-project:latest
```

## 🏗️ Terraform Infrastructure

The `terraform/` directory contains Infrastructure as Code for provisioning AWS resources:

```bash
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply
```

### Resources Created

- **EC2 Instance**: Builder instance (t3.medium) with Docker
- **Security Group**: SSH (22) and App (5001) access
- **Key Pair**: Auto-generated SSH key for instance access

### Configuration

Update `terraform/variables.tf` with your values:

- `vpc_id`: Your VPC ID
- `public_subnet_id`: Your public subnet ID
- `my_ip`: Your public IP (run `curl ifconfig.me`)

## 🔄 CI/CD Pipeline

The Jenkins pipeline automates the build and deployment process.

### Pipeline Stages

| Stage              | Description                                    |
| ------------------ | ---------------------------------------------- |
| Clone Repository   | Clones the GitHub repository                   |
| Linting            | Runs Flake8 (Python) and Hadolint (Dockerfile) |
| Security Scan      | Runs Bandit (Python) and Trivy (filesystem)    |
| Build Docker Image | Builds the Docker image                        |
| Push to Docker Hub | Pushes image to registry                       |

### Jenkins Setup

1. Install Jenkins on your Builder EC2 instance
2. Add DockerHub credentials:
   - `dockerhub-username` (Secret text)
   - `dockerhub-password` (Secret text)
3. Create a Pipeline job pointing to this repository

## 📁 Project Structure

```
rolling_project/
├── aws/                    # AWS documentation/screenshots
├── docs/                   # GitHub Pages documentation
│   └── index.html
├── python/                 # Flask application
│   ├── app.py              # Main application
│   └── requirements.txt    # Python dependencies
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # Main Terraform config
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output values
│   └── provider.tf         # AWS provider config
├── Dockerfile              # Docker build instructions
├── Jenkinsfile             # CI/CD pipeline definition
└── README.md               # This file
```

## 🔧 Technical Details

### Dependencies

- **Flask**: Web framework for the dashboard
- **Boto3**: AWS SDK for Python

### CI/CD Tools

- **Flake8**: Python code linting
- **Hadolint**: Dockerfile linting
- **Bandit**: Python security scanning
- **Trivy**: Container vulnerability scanning

## 🔒 Security Considerations

- **Credentials**: Never commit AWS credentials to version control
- **Permissions**: Use the principle of least privilege for AWS permissions
- **Scanning**: CI/CD pipeline includes security scanning with Bandit and Trivy
- **Environment**: Use environment variables or AWS IAM roles for credential management

## 🚨 Troubleshooting

### Common Issues

1. **AWS Credentials Not Found**
   - Ensure environment variables are set correctly
   - Check AWS credentials file (`~/.aws/credentials`)

2. **Permission Denied Errors**
   - Verify your AWS user has the required permissions
   - Check the IAM policy attached to your user/role

3. **Docker Build Fails**
   - Ensure Docker daemon is running
   - Check Dockerfile syntax

4. **Jenkins Pipeline Fails**
   - Verify DockerHub credentials are configured
   - Check Jenkins has Docker access

## 📝 License

This project is open source.

## 📞 Support

For issues and questions:

- Check the [documentation](https://maoridi.github.io/rolling_project/)
- Review the troubleshooting section
- Open an issue on GitHub

---

**Note**: This application makes real AWS API calls and will show actual resources from your AWS account.
