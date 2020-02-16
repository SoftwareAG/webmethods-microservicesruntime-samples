# Microservices Runtime with Docker and Jenkins

This project provides samples to create and push Docker images for webMethods Microservices Runtime using Jenkins pipeline.

Sample describes two different ways to build Docker image for Microservices Runtime.

1. [MSR_Docker](MSR_Docker) - Provides sample to create Docker image for Microservices Runtime starting with the installation of MSR on on-prem. For details, see [README](README_MSR_Docker.md).
2. [MSR_DockerHub](MSR_DockerHub) - Provides sample to create Docker image for Microservices Runtime from the base Docker image published on Dockerhub. For details, see [README](README_MSR_DockerHub.md).

## Getting Started

### Prerequisites

It is required that you have installed Docker and Jenkins in your environment.
 
**Note:** If above softwares are already installed, skip to "Setup" section. These samples are validated on RHEL and CentOS.

### Installing Docker

Follow the steps below to install Docker in your environment.

Install Docker:
```
sudo yum install docker
```

First remove older version of docker (if any):
```
sudo yum remove docker docker-common docker-selinux docker-engine-selinux docker-engine docker-ce
```

Install required packages
```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

Configure the docker-ce repo
```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

Install docker-ce
```
sudo yum install docker-ce
```

Start Docker
```
sudo systemctl start docker 

or 

sudo service docker start
```

### Installing Jenkins

Follow the steps below to install Jenkins in your environment.

Add the Jenkins repository to the yum repos, and install Jenkins from here.
```
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins
```

Jenkins requires Java in order to run, yet certain distros don't include this by default. To install the Open Java Development Kit (OpenJDK) run the following:
```
sudo yum install java
```

Start Jenkins
```
sudo service jenkins start
```

**Note:** Make sure port 8080 is accessible on the machine. You can use the following command to make port 8080 available.
```
sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT
```

Launch Jenkins as below and follow instructions in browser to change password and set up account
```
http://localhost:8080
```

### Setup

Login to Docker (Reference - https://docs.docker.com/engine/reference/commandline/login/)
```
sudo docker login -u [username] 
```

**Note:** Jenkins requires sudo permissions to run docker commands

Follow the steps below to provide sudo access to run docker from Jenkins

Open the file sudoers
```
sudo vi /etc/sudoers 
```

Add below line to the file
```
jenkins ALL=(ALL) NOPASSWD: ALL
```

## License

This project uses the Apache License Version 2.0. For details, see [the license file](../../LICENSE).

For more information about Microservices Runtime, see the official Software AG Microservices Runtime documentation.

______________________
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.	

Contact us at [TECHcommunity](mailto:technologycommunity@softwareag.com?subject=Github/SoftwareAG) if you have any questions.

