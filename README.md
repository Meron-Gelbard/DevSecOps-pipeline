# DevSecOps CI/CD Pipeline for Python Web App

This project implements a DevSecOps CI/CD pipeline for automation of Build, Test, and Deployment of a Python-Flask Weather Forecast web app. This GitHub Actions pipeline applies best practices of DevSecOps Shift-Left security measures for the continuous delivery of the app.

## Pipeline Stages Overview

### Static Application Security Testing (SAST) Job
- Static Python code analysis using *Bandit* 
- Library vurnerability scan using *Safety*
- SAST report generated on every build. Can be found in GitHub build artifacts.

### Build and Test Job
- **Process**:
  - Builds a new Docker image with the updated source code.
  - Public API keys passed as environment variables.
  - Runs vulnerability checks on the Docker image using Trivy.
  - Runs the image on GitHub agent as container.
  - Runs integration tests using a separate testing container.
- **Versioning**: Runs version increment script. Version saved in local file and pushed back to repo.
- **Image Signing**: Uses a Docker Trust signing key for image integrity.
- **Docker Hub**: Pushes the signed image with tags “latest” and new version.

### Terraform Deployment Job
- **Terraform Remote Back-End For Continuous IaC State Management**:
  - Checks if a remote backend exists
  - Creates an S3 bucket for the backend if dosen't exist.
  - Creates a DynamoDB table for backend state locking if dosen't exist.
- **Infrastructure Deployment**:
  - Deploys a full AWS VPC infrastructure based on security best practices.
  - Connects to the remote backend for management of infrastructure state.
- **App Deployment**:
  - Replaces old app instance with new ones upon successful version builds and updates.
  - App is deployed as a Docker container - Implemented using EC2 user data script.


### Applied Security Measures

**In Pipeline**
- Pre-build static analysis and library vulnerability checks.
- Post-build vulnerability scans on the app image.
- Signing and validating trusted signatures on new images.
- Implementing least privilege for the IAM role used in deployment. (Policies listed below.)

**Stored Credentials in GitHub Actions Secrets**
***For security, the following credentials are stored as GitHub Actions secrets:***
- Safety SAST service API key.
- External API keys for the Weather App (Geolocation and forecast services).
- Docker Trust signature key, passphrase (base64 encoded) and signer name.
- DockerHub credentials (username, password, image name).
- AWS IAM credentials (access key, access key ID, default region).

---

## AWS Architecture Features - Terraform IaC

### VPC Configuration
- AWS VPC with CIDR block of `10.0.0.0/16`.

### Internet Connectivity
- Internet Gateway linked to the VPC for internet access.

### Subnets
- One private subnet: `10.0.1.0/24`.
- Two public subnets: `10.0.2.0/24`, `10.0.3.0/24`.

### NAT Gateway
- NAT Gateway with Elastic IP for external connections from private subnet.
- Located in one of the public subnets.

### Routing Tables
  - NAT route table for the private subnet to get to IGW.
  - IGW route table for public subnets external connections.

### Network ACL (NACL) Security
#### Private Subnet NACL
- Inbound and outbound TCP traffic allowed within the VPC (`10.0.0.0/16`).
- Inbound rule for ephemeral ports (`1024-65535`) (For app external api connections).
- Outbound rules on port `443` for internet traffic.

#### Public Subnets NACL
- Inbound rules for HTTP (`80`), HTTPS (`443`) and ephemeral ports (`1024-65535`).
- Inbound rule for SSH (`22`) to bastion host.
- Outbound rule allowing all outbound internet traffic.

### Device Security Groups
**App Security Group**
- Allowing only VPC internal HTTP and SSH connections.

**ALB Security Group**
- Allowing all external HTTPS (`443`) traffic.

### App instance
- App EC2 instance in the private subnet.
- TLS key for secure SSH access store only on bastion host.
- App docker container deployment using a User-Data script executed on first spin-up.

### Load Balancer and Target Group
- Application Load Balancer for external access.
- Target Group for routing traffic to app EC2.
- HTTPS Listener on port `443` with SSL policy and Self-Signed certificate (Stored in IAM).




### Define these AWS IAM Policies on user role for applying Least Privileges:
**1. Amazon VPC Permissions**
- `ec2:CreateVpc`
- `ec2:DescribeVpcs`

**2. Internet Gateway Permissions**
- `ec2:CreateInternetGateway`
- `ec2:AttachInternetGateway`
- `ec2:DescribeInternetGateways`

**3. Subnet Permissions**
- `ec2:CreateSubnet`
- `ec2:DescribeSubnets`

**4. Route Tables and Routing Permissions**
- `ec2:CreateRouteTable`
- `ec2:AssociateRouteTable`
- `ec2:CreateRoute`
- `ec2:DescribeRouteTables`

**5. NAT Gateway Permissions**
- `ec2:CreateNatGateway`
- `ec2:DescribeNatGateways`

**6. Elastic IP Permissions**
- `ec2:AllocateAddress`
- `ec2:DescribeAddresses`

**7. Network ACL Permissions**
- `ec2:CreateNetworkAcl`
- `ec2:DescribeNetworkAcls`
- `ec2:CreateNetworkAclEntry`

**8. Security Group Permissions**
- `ec2:CreateSecurityGroup`
- `ec2:DescribeSecurityGroups`
- `ec2:AuthorizeSecurityGroupIngress`
- `ec2:AuthorizeSecurityGroupEgress`

**9. EC2 Instance Permissions**
- `ec2:RunInstances`
- `ec2:DescribeInstances`
- `ec2:TerminateInstances`

**10. Key Pair Permissions**
- `ec2:CreateKeyPair`
- `ec2:DescribeKeyPairs`

**11. Load Balancer Permissions**
- `elasticloadbalancing:CreateLoadBalancer`
- `elasticloadbalancing:DescribeLoadBalancers`
- `elasticloadbalancing:CreateTargetGroup`
- `elasticloadbalancing:DescribeTargetGroups`
- `elasticloadbalancing:RegisterTargets`
- `elasticloadbalancing:CreateListener`
