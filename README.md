# Deploying-EC2-Instance-in-AWS-Using-Terraform

Step 1. First clone this repo:
   git clone https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform.git

Step 2: Run the Terraform Commands to Create the EC2 Instance and the Underlying Infrastructure

Finally, we are now ready to deploy our AWS resources using Terraform. We must run “terraform init” to initialize the working directory that is holding the Terraform configuration files.

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/2.%20Running%20the%20terraform%20init%20command.png)

To make sure that the Terraform code is formatted correctly we will need to run “terraform fmt”. When I ran this command all of my Terraform configuration files were formatted correctly, if some files needed to have the formatting corrected, Terraform would correct the formatting, then display the file names at the prompt.

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/3.%20Running%20the%20terraform%20fmt%20command.png)

Next, best practices dictates that, we must run “terraform plan” to see a preview of the changes Terraform will make to our infrastructure.

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/4.%20Running%20the%20terraform%20plan%20command-1.png)
![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/5.%20Running%20the%20terraform%20plan%20command-2.png)

As can be seen from the screenshot above, Terraform will create 10 resources in AWS.

Now, let’s deploy our resources:

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/6.%20Running%20the%20terraform%20apply%20command.png)

You will be prompted to confirm that you want to perform these actions.
Enter “yes”.

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/7.%20Enter%20Yes.png)

Once the command completes, you should see an output similar to below:

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/8.%20Output%20of%20Running%20the%20terraform%20apply%20Command.png)

Congratulations! You have successfully deployed an EC2 instance running a webserver using Terraform. 

Step 3: Verify Infrastructure Has Been Deployed

To verify, we can go to the management console and check!

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/9.%20AWS%20Mangement%20Console-1.png)

We can copy the Public IP address from the management console and paste it in a web browser.

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/10.%20AWS%20Mangement%20Console-2.png)
![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/11.%20Test%20Website.png)

Step 4: Tear-down AWS Infrastructure

Run “terraform destroy” to terminate all the resources that were deployed during this lab.

![Screenshot](https://github.com/michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform/blob/main/images/12.%20Running%20the%20terraform%20destroy%20command.png)

Please see ... for the complete blog article!!

That completes this project! Thank you for reading!
