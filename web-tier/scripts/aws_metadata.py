import urllib.request import urlopen
import json

instance_id = urlopen('http://169.254.169.254/latest/meta-data/instance-id').read().decode('utf-8')

