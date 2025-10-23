variable "vpc_id" {
  description = "Existing VPC ID to deploy into"
  type        = string
  default     = "vpc-0b110d239f1211b4d"
}

variable "ami_id" {
  description = "Linux AMI that supports Docker (e.g., Amazon Linux 2)"
  type        = string
  default     = "ami-0c398cb65a93047f2"
}

variable "instance_type" {
  description = "Instance type to support Docker workloads"
  type        = string
  default     = "t3.medium"
}

variable "my_ip" {
  description = "Your public IP for SSH and HTTP access"
  type        = string
  # You can use https://ifconfig.me to get your IP and add /32
  default     = "146.185.57.74/32"
}

variable "public_subnet_id" {
  description = "Public subnet ID to launch the EC2 instance into"
  type        = string
  default     = "subnet-0852a4e422a2ea812"
}