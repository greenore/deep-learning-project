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

### Create instance
Search for “EC2” in the search bar. Click on “EC2” to start the EC2 wizard.

#### Step 1: Choose an Amazon Maschine Image (AMI)
![screen 1](/setup/img/step1.png "Screenshot 1")

- Select the Ubuntu Server 16.04 image

#### Step 2: Choose an Instance Type
![screen 2](/setup/img/step2.png "Screenshot 2")

- Select the free tier t2.micro instance. You're free to select a different one. This can also be changed later on when more capacity is needed. 

#### Step 3: Configure Instance Details
![screen 3](/setup/img/step3.png "Screenshot 3")

- When using p2.xlarge, click on “Request Spot Instances”. Spot instances are significantly cheaper than normal instances. It is a way for Amazon to sell excess capacity at reduced prices.
- (Optional) Click on “Enable CloudWatch Detailed Monitoring”. This will enable additional services like automatically shutting down an idle instance. You will be warned that additional charges may be incurred, which will go against your allotment. Consider it like buying insurance.
- (Optional) Under Advanced Details a custom startup script can be run. This can be usefull, when you're behind a company firewall and the ssh port (22) is blocked. In order to circumvent this, the following bash/perl script can be run. It runs the ssh on port 443:

```bash
#!/bin/bash -ex
perl -pi -e 's/^#?Port 22$/Port 22\nPort 443/' /etc/ssh/sshd_config
service ssh restart
```

#### Step 4: Add Storage
![screen 4](/setup/img/step4.png "Screenshot 4")

- The default SSD storage of 8 GB is sometimes not enough when installing all the cecessary software. That is why 30GB is chosen.

#### Step 5: Add Tags
![screen 5](/setup/img/step5.png "Screenshot 5")

- Nothing is changed/done here.

#### Step 6: Configure Security Group
![screen 6](/setup/img/step6.png "Screenshot 6")

- This is an important step. If the necessary ports are not opened, it isn't possible to connect to your RStudio/Anaconda Server.
- The following ports are opened: 80 (HTTP), 22 (SSH), HTTPS (443), RStudio Port (8787), Jupyter Port (8888).
- It is allowed to connect to them from any IP. It would also be possible to restrict the IP Range. 

#### Step 7: Review Instance Launch
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
- Select Import Key under Conversions
- Save as Private Key with RSA selected

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
## Install RStudio Server
Download and run the bash script 
```bash
wget https://raw.githubusercontent.com/greenore/deep-learning-project/master/setup/setup_rstudio.sh
chmod +x setup_rstudio.sh
sudo ./setup_rstudio.sh
```
### Add users for the RStudio environment
```bash
sudo adduser <username>
sudo adduser <username> sudo
```

### Copy ssh key
Copy the ssh key to the clipboard
```bash
cat ~/.ssh/authorized_keys
su <username>
cd ~
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
nano .ssh/authorized_keys
```

### Navigate to the RStudio Server
Start a local browser on your machine, and then navigate to the RStudio server running on AWS:

https://<your_AWS_public_DNS_name_or_IP_address>:8787

e.g.
https://ec2-54-198-210-216.compute-1.amazonaws.com:8787

## Install Anaconda
Download and run the bash script
**Note:** Anaconda is not installed globaly but rather localy for every user. That means you should run the script below with the user you plan to work with.
```bash
wget https://raw.githubusercontent.com/greenore/deep-learning-project/master/setup/setup_anaconda.sh
chmod +x setup_anaconda.sh
sudo ./setup_anaconda.sh
```
## Run jupyter notebook
To run jupyter notebook run the command below. The password is cs109b
```bash
jupyter notebook
```

## Fix language issues
In order to fix certain language issues, append the following lines to the */etc/environment* file.
```bash
sudo nano /etc/environment
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
```

## Enable Swapping
It might be necessary to enable swapping. This is especially the case with the smaller instances. You can make the size of 1024 also bigger.
```bash
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1
```
In order to activate swapping at startup append the following line to the */etc/fsab* file.
```bash
sudo nano /etc/fstab
swap        /var/swap.1 swap    defaults        0   0
```