# aws-ecs-fargate-terraform-app

# Kutt URL Shortener Infrastructure

![image](https://github.com/user-attachments/assets/b31c6be3-ee11-432f-8e54-64a86fbeaa80)


This repository contains Terraform configurations for deploying Kutt URL(https://github.com/thedevs-network/kutt) shortener on AWS, utilizing ECS Fargate, PostgreSQL RDS, and Redis ElastiCache.

## Architecture Overview

The infrastructure consists of the following components:

- **ECS Fargate**: Runs the Kutt application containers in a serverless environment
- **PostgreSQL RDS**: Manages persistent data storage
- **Redis ElastiCache**: Handles caching and session management
- **Application Load Balancer**: Distributes traffic to ECS tasks
- **VPC & Networking**: Secure network configuration with public and private subnets

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- Docker (for local testing)
- An AWS account with the necessary permissions

## Infrastructure Components

### 1. Networking
- VPC with public and private subnets
- Internet Gateway for public access
- NAT Gateway for private subnet internet access
- Route tables and security groups

### 2. ECS Configuration
- Fargate cluster
- Task definitions
- Service configurations
- Auto-scaling policies
- Container health checks

### 3. Database
- PostgreSQL RDS instance
- Multi-AZ deployment option
- Automated backups
- Parameter groups

### 4. Caching
- Redis ElastiCache cluster
- Replication groups
- Subnet groups

## Quick Start

1. Clone the repository:
```bash
git clone <repository-url>
cd kutt-infrastructure
