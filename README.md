## Challenge -1 ( web-tier )

1. To provision webtier just execute bootstrap script 
  ```./web-tier/scripts/bootstrap.sh```
1. and then to destroy them just execute destroy.sh script
  `./web-tier/scripts/destroy.sh`

A self-signed certificate was issued to the load balancer front end url.
Once ALB start processing requests, all web traffic should be routed towards ec2 instance behind the scene.

ALB dns name is shown in the terraform output.

## Challenge -2 ( Retrieve instance info..)

1. On aws ec2 instance just execute the script to retrieve and display instance details on from local metadata and AWS API
  ```python3 ./web-tier/scripts/describe_ec2_instance.py```
1. Anywhere else or to display remote aws instance details just specify its instance_id as arguement
  ```python3 ./web-tier/scripts/describe_ec2_instance.py <instance_id>```
    
## Challenge-3
Query nested json objects - here i'm using jq

```cat scripts/json-txt.json |jq ".Reservations[0].Instances[0].PublicDnsName"```
