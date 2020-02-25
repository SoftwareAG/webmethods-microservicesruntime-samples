# Microservices Runtime with Docker/Jenkins

This project allows user to perform the following steps using the Jenkins pipeline

1. Install SoftwareAG Microservices Runtime
2. Install update manager 
3. Install fixes
4. Configure Mircoservices Runtime
5. Create Docker image from installed and configured Mircoservices Runtime
6. Run tests against the Docker container started using the Docker image created above
7. Push the created Docker image into Docker registry

Follow the steps described in [README](README.md) for Prerequisites and initial setup of Docker and Jenkins.

## To install and run the sample

1. Create directory /opt/softwareag in your environment. This is the default directory, you can set it to any other value. Please ensure to use this directory in the Jenkins job.

2.	Clone the webmethods-microservicesruntime-samples repository. <br/>
`git clone https://github.com/SoftwareAG/webmethods-microservicesruntime-samples.git`

3.	Go to the resources directory of the repository. <br/>
`cd webmethods-microservicesruntime-samples/docker/jenkins/resources` i.e. *resources* folder.

4. Copy your license file(licenseKey.xml) into *resources* folder.

5. Download Software AG Installer(.bin) file for Linux from https://empower.softwareag.com/Products/DownloadProducts/sdc/default.aspx into *resources* folder. http://empowersdc.softwareag.com/dnld/wMInstaller/10.5/SoftwareAGInstaller20191216-LinuxX86.bin is one such example. Rename this file as installer.bin.

   ```
   sudo chmod 777 installer.bin
   ```

6. Download Software AG Update Manager Installer for Linux from https://empower.softwareag.com/Products/DownloadProducts/sdc/default.aspx into *resources* folder. http://empowersdc.softwareag.com/dnld/wMInstaller/10.5/SoftwareAGUpdateManagerInstaller20200214(LinuxX86).bin is one such example. Rename this file as updatemanager.bin.

   ```
   sudo chmod 777 updatemanager.bin
   ```

7. This step is required for supplying password to Update Manager. 
   * Download http://empowersdc.softwareag.com/dnld/wMInstaller/10.4/SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin
   * Install SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin in any desired location (lets say /opt/softwareag/sagsum103)
       ```
       sudo ./"SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin" --accept-license -d /opt/softwareag/sagsum103
       ```
   * Execute UpdateManagerCMD.sh from  /opt/softwareag/sagsum103/bin
   * Select option 9. Password Encryption, type your Empower password to encrypt the password 
   * Copy the encrypted password(lets say "abcdefgh") and replace empowerPwd as below format in sum.txt (if you follow above steps you would find sum.txt under *resources* folder)
       ```
       empowerPwd=abcdefgh
       ```

8. If jenkins is installed, copy 'webmethods-microservicesruntime-samples/docker/jenkins/MSR_Docker' folder into '/var/lib/jenkins/jobs' and execute following command to grant access permission

      ```
      sudo chmod 777 /var/lib/jenkins/jobs/MSR_Docker  -R
      ```

     Restart the jenkins
   ```
   sudo service jenkins restart
   ```
   
9. Change permission for test.sh under *resources* folder
      ```
      sudo chmod 777 test.sh
      ```

10. Login to Jenkins dashboard (http://localhost:8080) and click on "MSR_Docker" job.

11. Click "Build with Parameters" from the options in the left, provide valid parameters and click build. If everything is successful, you will see your Docker image published into the Docker registry.
   
![Jenkins Stage View](stageview.png)

## Jenkins Pipeline stages
Jenkins job has multiple stages in the pipeline.

##### Install MSR  
  Installs the MSR based on the parameters specified for installer Configurations.

##### Install SUM  
 Installs Update Manager that can be used to install latest fixes.

##### Install Fixes
 Installs all the fixes to the installed MSR.

##### Configure MSR
 This step is conditional. If APPLY_CONFIGURATION is set to YES then based on supplied ACDL configuration files, the configurations will be applied to the installed MSR. To create configuration files refer [Create configuration files](https://github.com/SoftwareAG/webmethods-microservicesruntime-samples/tree/master/docker/jenkins#create-configuration-files)

##### Create Docker File
 Creates Docker file for the installed MSR with latest fixes and applied configurations.

##### Build Docker Image
 Builds docker image from docker file created from previous step.

##### Start MSR
 Starts MSR in a Docker container.

##### Test
This stage allows to execute any tests on the Docker container.

##### Stop MSR
Stops the running Docker container.

##### Push docker image
Push the docker image into specified Docker registry with the tag specified.

##### Cleanup
Clean up the environment such as removing containers and images.


## Jenkins Parameters 
| Parameter               	| Description                                                                                                              	| Default                                                  	| Possible Values                                          	| Required                      	|
|-------------------------	|--------------------------------------------------------------------------------------------------------------------------	|----------------------------------------------------------	|----------------------------------------------------------	|-------------------------------	|
| SAG_DIR                 	| Directory to store resources such as SAG installer bin, SAG installer script, license key file, SUM script, test script. 	| /opt/softwareag/webmethods-microservicesruntime-samples/docker/jenkins/resources                                	|                                                          	| Yes                           	|
| INSTALL_FIXES            	| Installs fixes if set to YES                                                                              	| YES                                                       	|                                                          	| Yes                           	|
| APPLY_CONFIGURATION      	| Applies configuration if set to YES                                                                               	| NO                                                      	|                                                          	| Yes                           	|
| SAG_EMPOWER_USERNAME    	| Empower Username                                                                                                         	|                                                          	|                                                          	| Yes                           	|
| SAG_EMPOWER_PASSWORD    	| Empower Password                                                                                                         	|                                                          	|                                                          	| Yes                           	|
| SAG_INSTALLER_BIN       	| SAG installer bin file name                                                                                              	| SoftwareAGInstaller-Linux_x86_64.bin                     	|                                                          	| Yes                           	|
| SAG_INSTALLER_SCRIPT    	| SAG installer script file name                                                                                           	| msrInstallerLinuxScript_10_5.txt                         	| msrInstallerLinuxScript_10_5.txt                         	| Yes                           	|
|                         	|                                                                                                                          	|                                                          	| msrInstallerLinuxScript_10_3.txt                         	|                               	|
| SAG_INSTALLER_SANDBOX   	| Sandbox URL                                                                                                              	| https://sdc.softwareag.com/cgi-bin/dataservewebM105.cgi 	| https://sdc.softwareag.com/cgi-bin/dataservewebM105.cgi 	| Yes                           	|
|                         	|                                                                                                                          	|                                                          	| https://sdc.softwareag.com/cgi-bin/dataservewebM103.cgi 	|                               	|
| SAG_MSR_DIR             	| MSR installation directory                                                                                               	| /opt/softwareag/msr                                      	|                                                          	| Yes                           	|
| SAG_MSR_LICENSE_FILE    	| license file name                                                                                                        	| licenseKey.xml                                           	|                                                          	| Yes                           	|
| SAG_MSR_DEFAULT_PORT    	| MSR default port                                                                                                         	| 5555                                                     	|                                                          	| Yes                           	|
| SAG_MSR_DIAGNOSTIC_PORT 	| MSR diagnostic port                                                                                                      	| 9999                                                     	|                                                          	| Yes                           	|
| SAG_SUM_INSTALLER_BIN   	| SAG update manager installer bin file name                                                                               	| SoftwareAGUpdateManagerInstaller20191101(LinuxX86).bin   	| SoftwareAGUpdateManagerInstaller20191101(LinuxX86).bin   	| Yes                           	|
|                         	|                                                                                                                          	|                                                          	| SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin   	|                               	|
| SAG_SUM_DIR             	| SUM installed directory                                                                                                  	| /opt/softwareag/sagsum                                   	|                                                          	| Yes                           	|
| SAG_SUM_SCRIPT          	| SUM update manager script file name                                                                                      	| sum.txt                                                  	|                                                          	| Yes                           	|
| ACDL_FILE               	| ACDL filename to configure MSR                                                                                           	| isconfiguration.acdl                                     	|                                                          	| Depends on APPLY_CONFIGURATION 	|
| ACDL_BIN_FILE           	| ACDL package (.zip) filename to configure MSR                                                                            	| isconfiguration.zip                                      	|                                                          	| Depends on APPLY_CONFIGURATION 	|
| SAG_TEST_SCRIPT         	| Test script file name                                                                                                    	| test.sh                                                  	|                                                          	| Yes                           	|
| DOCKER_REPO_URL         	| Docker Repository                                                                                                        	|                                                          	|                                                          	| Yes                           	|
| DOCKER_TAG              	| Docker Tag                                                                                                               	| 10.5.0.2                                                 	|                                                          	| Yes                           	|
| DOCKER_BASE_IMAGE_NAME  	| Docker image name                                                                                                        	| centos:7                                                 	|                                                          	| Yes                           	|                                                  

## Examples
### Jenkins Parameters for Microservices Runtime 10.5 

   
| Parmeters               	| Values                                                            	|
|-------------------------	|-------------------------------------------------------------------	|
| SAG_DIR                 	| /opt/softwareag/webmethods-microservicesruntime-samples/docker/jenkins/resources                                         	|
| INSTALL_FIXES                	| YES                                                                	|
| APPLY_CONFIGURATION      	| NO                                                               	|
| SAG_EMPOWER_USERNAME    	| empower username                                                  	|
| SAG_EMPOWER_PASSWORD    	| empower password                                                  	|
| SAG_INSTALLER_BIN       	| ${SAG_DIR}/SoftwareAGInstaller20191216-LinuxX86.bin               	|
| SAG_INSTALLER_SCRIPT    	| ${SAG_DIR}/msrInstallerLinuxScript_10_5.txt                       	|
| SAG_INSTALLER_SANDBOX   	| https://sdc.softwareag.com/cgi-bin/dataservewebM105.cgi          	|
| SAG_MSR_DIR             	| /opt/softwareag/msr                                               	|
| SAG_MSR_LICENSE_FILE    	| ${SAG_DIR}/licenseKey.xml                                         	|
| SAG_MSR_DEFAULT_PORT    	| 5555                                                              	|
| SAG_MSR_DIAGNOSTIC_PORT 	| 9999                                                              	|
| SAG_SUM_INSTALLER_BIN   	| ${SAG_DIR}/SoftwareAGUpdateManagerInstaller20191101(LinuxX86).bin 	|
| SAG_SUM_DIR             	| /opt/softwareag/sagsum                                            	|
| SAG_SUM_SCRIPT          	| ${SAG_DIR}/sum.txt                                                	|
| ACDL_FILE               	| ${SAG_DIR}/isconfiguration.acdl                                   	|
| ACDL_BIN_FILE           	| ${SAG_DIR}/isconfiguration.zip                                    	|
| SAG_TEST_SCRIPT         	| ${SAG_DIR}/test.sh                                                	|
| DOCKER_REPO_URL         	| docker hub url                                                    	|
| DOCKER_TAG              	| 10.5.0.2                                                          	|
| DOCKER_BASE_IMAGE_NAME  	| centos:7                                                          	|

### Jenkins Parameters for Microservices Runtime 10.3

   
| Parmeters               	| Values                                                            	|
|-------------------------	|-------------------------------------------------------------------	|
| SAG_DIR                 	| /opt/softwareag/webmethods-microservicesruntime-samples/docker/jenkins/resources                                         	|
| INSTALL_FIXES                	| YES                                                               	|
| APPLY_CONFIGURATION      	| NO                                                               	|
| SAG_EMPOWER_USERNAME    	| empower username                                                  	|
| SAG_EMPOWER_PASSWORD    	| empower password                                                  	|
| SAG_INSTALLER_BIN       	| ${SAG_DIR}/SoftwareAGInstaller20191216-LinuxX86.bin               	|
| SAG_INSTALLER_SCRIPT    	| ${SAG_DIR}/msrInstallerLinuxScript_10_3.txt                       	|
| SAG_INSTALLER_SANDBOX   	| https\://sdc.softwareag.com/cgi-bin/dataservewebM105.cgi          	|
| SAG_MSR_DIR             	| /opt/softwareag/msr                                               	|
| SAG_MSR_LICENSE_FILE    	| ${SAG_DIR}/licenseKey.xml                                         	|
| SAG_MSR_DEFAULT_PORT    	| 5555                                                              	|
| SAG_MSR_DIAGNOSTIC_PORT 	| 9999                                                              	|
| SAG_SUM_INSTALLER_BIN   	| ${SAG_DIR}/SoftwareAGUpdateManagerInstaller20190930(LinuxX86).bin 	|
| SAG_SUM_DIR             	| /opt/softwareag/sagsum                                            	|
| SAG_SUM_SCRIPT          	| ${SAG_DIR}/sum.txt                                                	|
| ACDL_FILE               	| ${SAG_DIR}/isconfiguration.acdl                                   	|
| ACDL_BIN_FILE           	| ${SAG_DIR}/isconfiguration.zip                                    	|
| SAG_TEST_SCRIPT         	| ${SAG_DIR}/test.sh                                                	|
| DOCKER_REPO_URL         	| docker hub url                                                    	|
| DOCKER_TAG              	| 10.3.0.9                                                        	|
| DOCKER_BASE_IMAGE_NAME  	| centos:7                                                          	|

## Create Install Script for Microservices Runtime  
This sample provides default install script - msrInstallerLinuxScript_10_3.txt and msrInstallerLinuxScript_10_5.txt. 

To create install script( SAG_INSTALLER_SCRIPT  parameter) for Microservices Runtime from SAG Installer follow the steps in below links

* 10.5 - https://documentation.softwareag.com/a_installer_and_update_manager/10-5_Software_AG_Installer_webhelp/index.html#page/using-sag-installer-webhelp/to-console_mode_18.html
* 10.3  -  https://documentation.softwareag.com/a_installer_and_update_manager/10-3_Software_AG_Installer_webhelp/index.html#page/using-sag-installer-webhelp/to-console_mode_17.html

## License

This project uses the Apache License Version 2.0. For details, see [the license file](../../LICENSE).

For more information about Microservices Runtime, see the official Software AG Microservices Runtime documentation.

______________________
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.	

Contact us at [TECHcommunity](mailto:technologycommunity@softwareag.com?subject=Github/SoftwareAG) if you have any questions.
