# Deploying-EC2-Instance-in-AWS-Using-Terraform

We will want to check that all files were created. I need to run the “ls” command since I am working on a Fedora Linux VM.
 

Code: ls


Note: I have the terraform.tfstate and terraform.tfstate.backup files in my directory because I have already ran terraform init and these files are created when that command is ran.


Step 3: Run the Terraform Commands to Create the EC2 Instance and the Underlying Infrastructure

Finally, we are now ready to deploy our AWS resources using Terraform. We must run “terraform init” to initialize the working directory that is holding the Terraform configuration files.

Code: terraform init




To make sure that the Terraform code is formatted correctly we will need to run “terraform fmt”. When I ran this command all of my Terraform configuration files were formatted correctly, if some files needed to have the formatting corrected, Terraform would correct the formatting, then display the file names at the prompt.

Code: terraform fmt



Next, best practices dictates that, we must run “terraform plan” to see a preview of the changes Terraform will make to our infrastructure.

Code: terraform plan


As can be seen from the screenshot above, Terraform will create 10 resources in AWS.

Now, let’s deploy our resources:

Code: terraform apply


You will be prompted to confirm that you want to perform these actions.
Enter “yes”.











Once the command completes, you should see an output similar to below:



Congratulations! You have successfully deployed an EC2 instance running a webserver using Terraform. 

Step 4: Verify Infrastructure Has Been Deployed

To verify, we can go to the management console and check!


We can copy the Public IP address from the management console and paste it in a web browser.



Step 5: Tear-down AWS Infrastructure

Run “terraform destroy” to terminate all the resources that were deployed during this lab.


That completes this project! Thank you for reading! 
