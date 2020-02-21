import sys
import json
import datetime
import urllib3
import boto3
from botocore.exceptions import ClientError

if len(sys.argv) == 1:
  url = 'http://169.254.169.254/latest/meta-data/instance-id'
  http = urllib3.PoolManager()
  resp = http.request('GET', url)
  instance_id = resp.data
else:
  instance_id = sys.argv[1]

print("\nRetrieving details for the instance : %s \n" %instance_id)

ec2 = boto3.client('ec2', 'eu-west-1')

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

try:
  resp = instance = ec2.describe_instances(InstanceIds=[instance_id])
  print(json.dumps(resp, indent=1, default = myconverter))
except ClientError as e:
  print(e)
