## Work in progess ..

# Microservices Runtime  with DockerHub/Jenkins

This project allows user to quickly pull docker image, apply configurations, commit docker image and push docker image

## Getting Started
### Prerequisites

  Install below softwares 
 * Docker
 * Jenkins
 
**Note:** If above softwares were already installed, check 'Installing Docker' and 'Installing Jenkins and providing sudo sccess' sections below to verify all steps were covered and scroll down to 'one time setup'
### Installing Docker (CentOS 7 / RHEL 7)

A step by step series of examples that tell you how to install Docker in CentOS 7 / RHEL 7

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
Start Docker using systemctl
```
sudo systemctl start docker
```
or Start Docker using service
```
sudo service docker start
```
Login to Docker (Reference - https://docs.docker.com/engine/reference/commandline/login/)
```
sudo docker login -u [username] 
```

### Installing Jenkins and providing sudo sccess

A step by step series of examples that tell you how to install Jenkins and provide sudo access to run docker

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

Launch Jenkins as below and follow instructions in browser to change password and set up account
```
http://localhost:8080
```
**Note:** Jenkins requires sudo permissions to run docker commands

Open the file sudoers
```
sudo vi /etc/sudoers 
```
Add below line to the file
```
jenkins ALL=(ALL) NOPASSWD: ALL
```


### One time setup
 * Create folder /opt/softwareag/resources
 * Clone current repository into /opt/softwareag/resources
 * cd into /opt/softwareag/resources and it would contain MSR_DockerHub folder, wm-deploy.jar 
 * Copy Configurations files(isconfiguration.acdl and isconfiguration.zip) into /opt/softwareag/resources
 * If jenkins is installed, copy 'MSR_DockerHub' folder into '/var/lib/jenkins/jobs' and restart the jenkins
   ```
   sudo service jenkins restart
   ```
  * After restart, click "MSR_DockerHub" in Jenkins dashboard (http://localhost:8080).
  * Click "Build with Parameters" from the options in the left
  * Provide valid parameters and click build.
   
## Jenkins Pipeline stages
##### Pull Docker  
  Pulls Docker from the given docker repo and tag

##### Start MSR
 Starts the MSR in port 5555 within the  docker container 

##### Configure MSR
 Configures the MSR with given configuration files

##### Stop MSR
 Stop the running container

#####  Docker Commit 
 Commits the Configured Docker image with new tag

##### Push docker image
Push the Configured Docker image into specified Docker hub URL

##### Cleanup
Clean up the environment such as removing containers and images.

## Jenkins Parameters 
| Parameter            	| Description                                                                                   	| Default                   	| Required 	|
|----------------------	|-----------------------------------------------------------------------------------------------	|---------------------------	|----------	|
| SAG_DIR              	| Directory to store resources such as isconfiguration.acdl, isconfiguration.zip, wm-deploy.jar 	| /opt/softwareag/resources 	| Yes      	|
| DOCKER_REPO_URL      	| Docker Repository                                                                             	|                           	| Yes      	|
| DOCKER_TAG           	| Docker Tag                                                                                    	|                           	| Yes      	|
| SAG_MSR_DEFAULT_PORT 	| MSR default port                                                                              	| 5555                      	| Yes      	|
| ACDL_FILE            	| ACDL filename to configure MSR                                                                	| isconfiguration.acdl      	| Yes      	|
| ACDL_BIN_FILE        	| ACDL package (.zip) filename to configure MSR                                                 	| isconfiguration.zip       	| Yes      	|
| DOCKER_COMMIT_TAG    	| Docker Commit Tag                                                                             	|                           	| Yes      	|         
## Examples
### Jenkins Parameters for Software AG Microservices Runtime 10.5.0.0 

| Parmeters            	| Values                                           	|
|----------------------	|--------------------------------------------------	|
| SAG_DIR              	| /opt/softwareag/resources                        	|
| DOCKER_REPO_URL      	| store/softwareag/webmethods-microservicesruntime 	|
| DOCKER_TAG           	| 10.5.0.0                                         	|
| SAG_MSR_DEFAULT_PORT 	| 5555                                             	|
| ACDL_FILE            	| ${SAG_DIR}/isconfiguration.acdl                  	|
| ACDL_BIN_FILE        	| ${SAG_DIR}/isconfiguration.zip                   	|
| DOCKER_TAG           	| 10.5.0.0_1                                       	|


## License

This project uses the Apache License Version 2.0. For details, see [the license file](LICENSE).

For more information about Microservices Runtime, see the official Software AG Microservices Runtime documentation.

______________________
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.	

Contact us at [TECHcommunity](mailto:technologycommunity@softwareag.com?subject=Github/SoftwareAG) if you have any questions.

