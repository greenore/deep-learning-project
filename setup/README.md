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
Log in to the AWS Console and click on the EC2 icon under Compute. Now setup a environment.

![screen 1](/img/step1.png "Screenshot 1")
![screen 2](/img/step2.png "Screenshot 2")
![screen 3](/img/step3.png "Screenshot 3")
![screen 4](/img/step4.png "Screenshot 4")
![screen 5](/img/step5.png "Screenshot 5")
![screen 6](/img/step6.png "Screenshot 6")
![screen 7](/img/step7.png "Screenshot 7")

## Log into your virtual machine
ssh into the environment.

## Setup and run the bash script
Run the bash script 
```bash
wget 
```

## Add users for the RStudio environment
```bash
sudo adduser <username>
sudo adduser <username> sudo
```
