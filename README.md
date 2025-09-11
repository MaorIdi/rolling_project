# AWS Resource Dashboard

A Flask-based web application that provides a real-time dashboard for viewing AWS resources in your account. The application displays EC2 instances, VPCs, Load Balancers, and AMIs in an organized, easy-to-read format.

## 🚀 Features

- **EC2 Instances**: View instance ID, state, type, and public IP address
- **VPC Information**: Display VPC IDs and their CIDR blocks
- **Load Balancers**: Show load balancer names and DNS names
- **AMI Images**: List custom AMIs owned by your account
- **Real-time Data**: Fetches live data directly from AWS APIs
- **Clean UI**: Simple, responsive web interface with organized tables

## 📋 Prerequisites

- Python 3.7 or higher
- AWS Account with appropriate permissions
- AWS credentials configured

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
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

You need to configure AWS credentials using environment variables. Create a `.env` file or set the following environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_REGION="your-preferred-region"  # e.g., us-east-1, eu-west-1
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

1. **Set your AWS credentials** (if not already done):
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key-id"
   export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
   export AWS_REGION="us-east-1"
   ```

2. **Start the Flask application**:
   ```bash
   python app.py
   ```

3. **Access the dashboard**:
   Open your web browser and navigate to: `http://localhost:5001`

## 📁 Project Structure

```
rolling_project/
├── aws/
│   ├── my_aws_ec2.png          # AWS EC2 screenshot/reference
│   └── rolling_project_web.png # Web application screenshot
├── python/
│   ├── app.py                  # Main Flask application
│   └── requirements.txt        # Python dependencies
└── README.md                   # This file
```

## 🔧 Technical Details

### Dependencies

- **Flask**: Web framework for the dashboard
- **Boto3**: AWS SDK for Python
- **Botocore**: Core functionality for AWS services

### Application Architecture

- **Frontend**: HTML templates with inline styling
- **Backend**: Flask web server
- **AWS Integration**: Boto3 SDK for AWS API calls
- **Data Flow**: Real-time API calls → Data processing → HTML rendering

### Supported AWS Services

1. **EC2 (Elastic Compute Cloud)**
   - Instance details
   - Instance states
   - Public IP addresses

2. **VPC (Virtual Private Cloud)**
   - VPC IDs
   - CIDR blocks

3. **ELB (Elastic Load Balancing)**
   - Load balancer names
   - DNS names

4. **AMI (Amazon Machine Images)**
   - Custom AMIs (account-owned only)
   - AMI names and IDs

## 🌐 Usage

Once the application is running:

1. Navigate to `http://localhost:5001`
2. View your AWS resources organized in separate tables
3. Data is fetched in real-time from your AWS account
4. Refresh the page to update the information

## 🔒 Security Considerations

- **Credentials**: Never commit AWS credentials to version control
- **Permissions**: Use the principle of least privilege for AWS permissions
- **Network**: Consider running behind a reverse proxy in production
- **Environment**: Use environment variables or AWS IAM roles for credential management

## 🚨 Troubleshooting

### Common Issues

1. **AWS Credentials Not Found**
   - Ensure environment variables are set correctly
   - Check AWS credentials file (`~/.aws/credentials`)

2. **Permission Denied Errors**
   - Verify your AWS user has the required permissions
   - Check the IAM policy attached to your user/role

3. **Connection Timeout**
   - Verify your internet connection
   - Check if AWS region is correctly specified

4. **Application Won't Start**
   - Ensure all dependencies are installed: `pip install -r requirements.txt`
   - Check if port 5001 is available

### Debug Mode

The application runs in debug mode by default. For production deployment:

```python
app.run(host="0.0.0.0", port=5001, debug=False)
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is open source. Please check the license file for details.

## 📞 Support

For issues and questions:
- Check the troubleshooting section above
- Review AWS documentation for API limitations
- Ensure proper AWS credentials and permissions

---

**Note**: This application makes real AWS API calls and will show actual resources from your AWS account. Ensure you have the proper permissions and understand the costs associated with AWS API calls.
