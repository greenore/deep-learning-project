# Cloud Setup Instructions
## Amazon Web Services (EC2)
Amazon Web Services (AWS) is a platform that offers a bewildering array of cloud computing services. Their flagship product is Elastic Compute Cloud (EC2) which gives users the ability to quickly deploy virtual computers (called instances) in the cloud. The specifications (number of cores, RAM, and storage) of an instance can be tailored to the size and complexity of the task, and users pay an hourly rate that depends on the computing power of the instance.

The diversity and flexibility of AWS makes it extremely powerful; however, it also makes simple tasks daunting and confusing. With this in mind, this instructions will focus on a single, well-defined goal: setting up RStudio Server installed on an AWS EC2 instance so that RStudio can be accessed via the browser from anywhere. The only prerequisite is an AWS account, which you can sign up for if you haven’t already. A credit card is required to sign up, but you will only be charged for computing time you use, and Amazon offers an excellent free tier that is suitable for small jobs.

## Motivation
At the end of those instructions, you’ll have RStudio running in the cloud on AWS and accessible via your web browser. Advantage of the cloude environment are:

- Free-up local resources
- Collaborations and seamlessly work across locations
- Computing power

## Deploying an EC2 instance
Log in to the AWS console (https://aws.amazon.com) and click on the EC2 icon under Compute. 

### Switch region
From the region button on top right. Select US East (N.Virginia) 
![switch region](/setup/img/image04.png "Switch region")


### Create instance

- Search for “EC2” in the search bar. Click on “EC2” to start the EC2 wizard.
- Click on the big blue “Launch instance” button


#### Step 1
![screen 1](/setup/img/step1.png "Screenshot 1")

#### Step 2
![screen 2](/setup/img/step2.png "Screenshot 2")

#### Step 3
![screen 3](/setup/img/step3.png "Screenshot 3")
- When using p2.xlarge, click on “Request Spot Instances”. Spot instances are significantly cheaper than normal instances. It is a way for Amazon to sell excess capacity at reduced prices.
- (Optional) Click on “Enable CloudWatch Detailed Monitoring”. This will enable additional services like automatically shutting down an idle instance. You will be warned that additional charges may be incurred, which will go against your allotment. Consider it like buying insurance. 

#### Step 4
![screen 4](/setup/img/step4.png "Screenshot 4")

#### Step 5
![screen 5](/setup/img/step5.png "Screenshot 5")

#### Step 6
![screen 6](/setup/img/step6.png "Screenshot 6")

#### Step 7
![screen 7](/setup/img/step7.png "Screenshot 7")
- When you attempt to launch the instance it will ask if you have a keypair.
- If you have not used SSH before and do not have a keypair, select “Create a new keypair”
- Download the .pem file and store it in a safe place
- You will need to import the .pem file to connect your instance over ssh. See below.

## Log into your instance
Connect to the instance over ssh which establishes a terminal session to your newly created instance.

### For Windows Users
Windows users may not have an ssh client installed. If you need ssh for Windows, download PuTTY (http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). 

You will need to convert the .pem key from AWS into a .ppk key in PuTTY Key Generator
●	Select Import Key under Conversions
●	Save as Private Key with RSA selected
![putty key](/setup/img/image06.png "puTTY key generator")

Launch PuTTY and you will see the below screen.  
![putty](/setup/img/image02.png "puTTY")

Navigate to SSH > Auth, browse to add the .ppk file and Open
![putty aut](/setup/img/image00.png "puTTY auth")

Login as user ubuntu

### For MacOS and Linux users

Open a terminal window. 
**Note:** On a Mac or on Linux you may need to change the permissions of your ssh keyfile if you get the following error when attempting to ssh to your instance:

“Permission denied (publickey)”

Change the permission of your ssh keyfile as follows if you get the above error message.

```bash
chmod 600 <ssh_key>
```
Use the public IP of the running instance and username “ubuntu”.  For example:
```bash
ssh -i <your_ssh_keyfile> ubuntu@<your_AWS_public_DNS_name_or_IP_address>
```
## Setup and run the bash script
Download and run the bash script 
```bash
wget https://raw.githubusercontent.com/greenore/deep-learning-project/master/setup/setup.sh.sh
chmod +x setup.sh
sudo ./setup.sh
```
## Add users for the RStudio environment
```bash
sudo adduser <username>
sudo adduser <username> sudo
```
## Navigate to the RStudio Server
Start a local browser on your machine, and then navigate to the RStudio server running on AWS:

https://<your_AWS_public_DNS_name_or_IP_address>:8787

e.g.
https://ec2-54-198-210-216.compute-1.amazonaws.com:8787
