# AWS-VPC-PROJECT
AWS-VPC PROJECT--- used for servers in production enviroment.

🚀Understanding the concept of-AWS virtual private cloud (VPC)  may seems arduous & complex for many of us ...
👉But though i am effectively get over some complex concepts of VPC  and successfully completed the project on AWS VPC –that is used for servers in production enviroment

🎯PROJECT OVERVIEW🌐


🔗Creating a VPC == To improve resiliency 
                                 ➤servers are deployed in two availabilty zones by using
                                 ➤Auto scaling groups & 
                                 ➤application load balancer 
                                 ➤There is one public and one private subnets in both the availabilty zones
                                 ➤For additional security we deploy servers on private subnets 
                                 ➤Each public subnet contains NAT GATEWAY
                                 ➤uses SECURITY GROUPS for additional security
                                 ➤Bastien host for masking the private subnet ec2 ip-address

🔁Auto-Scaling-Groups == By integrating Auto-scaling groups we can achieve  
                                                  ➤Dynamic scaling ➤High availabilty ➤efficient resource                                                                                                                                                 managment  ➤the network isolation and security.

⚖️Load-Balancer ==  It distributes incoming traffic across multiple instances, ensuring 
                                                   ➤fault tolerance ➤maximizing resources utlization

📡NAT-gateways == Enables the instances in private subnets to access the internet .
 
🔑Security Groups == Presents at private subnets which allows the specific request to application.


🔗Now here we install our application on ec2 instances , and login in this private ec2 instances via bestian host which mask the private ip-addresses of ec2 instances for secure and safe login.


Workflow of Aws-vpc ➤when user wants to access application from outer internet, request flows from internet gatewway in vpc to application load balancer present in public subnets with target groups present in it which targets the applications present in instances. Then requests flows from load balencer to applications present in ec2 instances in private subnets with the help of route table which decides the route of requests and flows to its target application.
