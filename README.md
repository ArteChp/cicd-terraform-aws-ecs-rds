# Terraform Infrastructure Setup and Automatically build and deploy a Java application to Amazon ECS using a DevSecOps CI/CD pipeline

### Infrastructure Overview:
This project showcases an experience in design, manage, and deploy a secure containerized infrastructure using Terraform, AWS, Git, and CI/CD pipelines. The setup includes an ECS cluster for containerized applications, a RDS instance, and a secure location for storing secrets. The infrastructure is designed to be reusable for both development and production environments.

### Goals and Objectives:

#### Reusable Infrastructure:
- Created reusable Terraform code for both development and production environments.
- Set up essential components for a secure infrastructure including IAM roles, security groups, ACLs, and load balancers.

#### Version Control:
- Stored both Terraform code and application code in a Git repository.
- Application code consists of a simple "Hello, World!!!" webpage with the URL (http://[alb.dns.name]/hello).

#### Automated Deployments:
- Implemented a CI/CD pipeline using AWS CodePipeline, CodeBuild, CodeDeploy.
- Automates deployments triggered by branch merges:
    - Changes merged into the `main` branch are deployed to the production environment.
    - Changes merged into the `develop` branch are deployed to the testing environment.

#### Tags: 
- All resources are tagged with `name:csgtest` for easy identification and management.

### Infrastructure Details:

#### ECS Cluster with Task Definition:
- Configured ECS Cluster with the module `terraform-aws-modules/ecs/aws`.
- Task definitions include environment variables specifying the appropriate environment (development or production).

#### Load balancing:
- Configured AWS Application Load Balancer (ALB) with the module `terraform-aws-modules/alb/aws`.

#### RDS Instance:
- Provisioned a secure and scalable RDS instance for database needs with the module `terraform-aws-modules/rds/aws`.

#### Secret Management:
- Used AWS Secrets Manager to securely store and manage secrets.

#### Security:
- Provisioned a secure AWS VPC: private, public, and database subnets with the module `terraform-aws-modules/vpc/aws`
- Implemented robust security measures including IAM roles/policies, security groups, and ACLs with module `terraform-aws-modules/security-group/aws`.

### Terraform backend:
- Configured state storage as a key in Amazon S3 bucket with the module `terraform-aws-modules/s3-bucket/aws`  

### High Level Architecture of the infrastructure:

![Alt text](./infra-diagram.png?raw=true "Infrastructure Architecture")

### CI/CD Overview:
Created a continuous integration and continuous delivery (CI/CD) pipeline that automatically builds and deploys a Java application to an Amazon Elastic Container Service (Amazon ECS) cluster on the Amazon Web Services (AWS) Cloud. This pattern uses a greeting application developed with a Spring Boot Java framework and that uses Apache Maven.

This solution will be useful to build the code for a Java application, package the application artifacts as a Docker image, security scan the image, and upload the image as a workload container on Amazon ECS and can be also used as a reference to migrate from a tightly coupled monolithic architecture to a microservices architecture. 
It also emphasizes on how to monitor and manage the entire lifecycle of a Java application, which ensures a higher level of automation and helps avoid errors or bugs and has been implemented with best DevSecOps Pipeline practices.


### High Level Architecture of CI/CD:

![Alt text](./cicd-diagram.png?raw=true "CI/CD Architecture")

The diagram shows the following workflow:

1. Developer will update the Java application code in the main/develop branch of the AWS CodeCommit repository.

2. Amazon CodeGuru Reviewer automatically reviews the code if a Pull Request is submitted and does a analysis of java code as per the best practices and gives recommendations to users.

3. Once the code is pushed to the repository, a AWS CloudWatch event is created.

4. This AWS CloudWatch event triggers the AWS CodePipeline.

5. CodePipeline runs the security scan stage (continuous security).

6. CodeBuild first starts the security scan process in which Dockerfile, Terraform files are scanned using Checkov and application source code is scanned using AWS CodeGuru CLI based on incremental code changes.

7. Next, if the security scan stage is successful, the build stage(continuous integration) is triggered.

8. In the Build Stage, CodeBuild builds the artifact, packages the artifact to a Docker image, scans the image for security vulnerabilities by using Aqua Security Trivy, and stores the image in Amazon Elastic Container Registry (Amazon ECR).

9. The vulnerabilities detected from step 6 are uploaded to AWS Security Hub for further analysis by users or developers, which provides overview, recommendations, remediation steps for the vulnerabilties.

10. Emails Notifications of various phases within the AWS CodePipeline are sent to the users via Amazon SNS.

11. After the continuous integration phases are complete, CodePipeline enters the deployment phase (continuous delivery).

12. The Docker image is deployed to Amazon ECS as a container workload (Task) using AWS CodeDeploy. 

### Code Structure:

```bash
├── README.md
├── alb.tf 
├── backend.tf 
├── ecs.tf 
├── iam.tf 
├── main.tf 
├── namespaces.tf 
├── outputs.tf 
├── rds.tf 
├── s3.tf 
├── securitygroups.tf 
├── securitymanager.tf 
├── variables.tf 
├── vpc.tf 
├── backend.tfvars
├── terraform.tfvars 
├── cicd-diagram.png
├── infra-diagram.png
├── buildspec
│   ├── buildspec.yml
│   └── buildspec_secscan.yaml
├── cf_templates
│   ├── build_deployment.yaml
│   └── codecommit_ecr.yaml
├── code
│   └── app
│       ├── Dockerfile
│       ├── pom.xml
│       └── src
│           └── main
│               ├── java
│               │   └── software
│               │       └── amazon
│               │           └── samples
│               │               └── greeting
│               │                   ├── Application.java
│               │                   └── GreetingController.java
│               └── resources
│                   └── Images
│                       └── aws_proserve.jpg
└── securityhub
    └── asff.tpl

```
### Code Overview:

1) **.tf,.tfvars**: **Terraform** infrastructure files 
```bash
├── alb.tf 
├── backend.tf 
├── ecs.tf 
├── iam.tf 
├── main.tf 
├── namespaces.tf 
├── outputs.tf 
├── rds.tf 
├── s3.tf 
├── securitygroups.tf 
├── securitymanager.tf 
├── variables.tf 
├── vpc.tf 
├── backend.tfvars
├── terraform.tfvars 
```

2) **buildspec**: BuildSpec yaml files, **buildspec.yml** (For Build Phase),  **buildspec_secscan.yaml** (For CodeSecurityScan Phase)
```bash
buildspec
├── buildspec.yml (Build)
└── buildspec_secscan.yaml(CodeSecurityScan)
```

3) **cf_templates**: Cloudformation templates 
```bash
cf_templates
├── build_deployment.yaml (Pipeline Stack Setup)
└── codecommit_ecr.yaml (Codecommit and ECR Setup)
```

4) **code**: Sample Spring Boot application source code (src folder), Dockerfile and pom.xml
```bash
code
└── app
    ├── Dockerfile
    ├── pom.xml
    └── src
        └── main
            ├── java
            │   └── software
            │       └── amazon
            │           └── samples
            │               └── greeting
            │                   ├── Application.java
            │                   └── GreetingController.java
            └── resources
                └── Images
                    └── aws_proserve.jpg
```

5) **securityhub**: ASFF template (**AWS Security Finding Format**, part of AWS SeurityHub service). This format will be used for uploading docker image vulnerabilties details to AWS SecurityHub
```bash
securityhub
└── asff.tpl
```

