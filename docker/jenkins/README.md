# Microservices Rumtime  with docker/jenkins

This project allows user to quickly install Mircoservices Runtime, install fixes, install update manager, configure Mircoservices Runtime , build Mircoservices Runtime docker image and push the image into DockerHub using Jenkins pipeline.

## Getting Started
### Prerequisites

  Install below softwares (if below softwares were already installed, scroll down to 'one time setup')
 * Docker
 * Jenkins

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

Docker push "x509: certificate signed by unknown authority" counter measures 
```
 sudo chmod 777 -R /home/EUR/{useraccount}
 sudo chmod 777 -R /etc/ssl/certs
 curl -k https://daerepository03.eur.ad.sag:4443/ca | sudo tee -a /home/EUR/{useraccount}/server.pem
 cat /home/EUR/{useraccount}/server.pem >> /etc/ssl/certs/ca-certificates.crt
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
 * Download MSR_Docker folder, msrInstallerLinuxScript_10_3.txt, msrInstallerLinuxScript_10_5.txt, sum.txt, test.sh, wm-deploy.jar from current folder
 * Create folder /opt/softwareag/resources
 * Download Software AG Installer(.bin) file for Linux from https://empower.softwareag.com/
 * Download Software AG Update Manager Installer(SoftwareAGUpdateManagerInstaller20191101(LinuxX86).bin and SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin from https://empower.softwareag.com/ 
 * Copy license file(licenseKey.xml) into /opt/softwareag/resources
 * Place all downloaded resources under /opt/softwareag/resources
 * Install SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin in any desired location (lets say /opt/softwareag/sagsum)
 * Execute UpdateManagerCMD.sh from  /opt/softwareag/sagsum/bin
 * Select option 9. Password Encryption, type Empower password to encrypt the password 
 * Copy the encrypted password(lets say "abcdefgh") and replace empowerPwd as below format in sum.txt (downloads from GitHub)
      *  empowerPwd=abcdefgh
 * If jenkins is installed, copy 'MSR_Docker' folder into '/var/lib/jenkins/jobs' and restart the jenkins
   ```
   sudo service jenkins restart
   ```
  * After restart, click "MSR_Docker" in Jenkins dashboard (http://localhost:8080).
  * Click "Build with Parameters" from the options in the left
  * Provide valid parameters and click build.
   
## Jenkins Pipeline 12 stages
##### Install MSR  
  Installs the MSR based on the parameters specified for Installer Configurations
##### Install SUM  
 Installs Update Manager based on specified bin file
##### Install Fixes
 Installs all the fixes to the installed MSR

##### Configure MSR
 This step is conditional. If SKIP_CONFIGURATION is set to NO then based on MSR Pre-Configurations, the configurations will be applied to the installed MSR

##### Create Docker File
 Creates Docker file for the installed MSR with latest fixes and optionally configurations.

##### Build Docker Image
 Builds docker image from docker file created from previous step.

##### Start MSR
 Starts the MSR in port 5555 within the  docker container 

##### Docker Info
Displays the docker images and process status of the running container

##### Test
Test the running container based on test.sh 

##### Stop MSR
Stop the running container

##### Push docker image
Push the docker image into specified Docker hub URL

##### Cleanup
Clean up the environment such as removing containers and images.
Explain how to run the automated tests for this system


## License

This project uses the Apache License Version 2.0. For details, see [the license file](LICENSE).


