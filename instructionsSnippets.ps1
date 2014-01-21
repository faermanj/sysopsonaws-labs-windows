#Interacting with CloudWatch

## Topic 3.2

wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts-v1.1.0.zip
unzip CloudWatchMonitoringScripts-v1.1.0.zip 
rm CloudWatchMonitoringScripts-v1.1.0.zip 
cd aws-scripts-mon


## Topic 3.3

./mon-put-instance-data.pl --mem-avail

## topic 3.4 

echo "*/5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-avail" | crontab 

## Topic 5.1

aws cloudwatch get-metric-statistics \
 --metric-name "MemoryAvailable" \
 --namespace="System/Linux" \
 --start-time=$(date -d yesterday -I) \
 --end-time=$(date -d tomorrow -I) \
 --period=300 \
 --statistics="Minimum" \
 --dimensions Name=InstanceId,Value=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
 --region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed -e 's/.$//')

## Topic 3.4

curl -s https://raw.github.com/awstrainingandcertification/sysopsonaws-labs-linux/master/MonitoringLab/allocateMemory.py | python -

# Integrating with Other Monitoring Services

## Start the Monitoring Server - Topic 4

#!/bin/bash
easy_install pip
pip install setuptools --no-use-wheel --upgrade
pip install Flask
curl -s -O -L https://github.com/awstrainingandcertification/sysopsonaws-labs-linux/archive/master.zip
unzip master.zip -d /usr/local/
python /usr/local/sysopsonaws-labs-linux-master/MonitoringLab/server.py &

## Client Self-Registration - Topic 7

#!/bin/bash
curl -X PUT \
  -d instanceId=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
 [monitoring_server_url]

## Schedule the scan / config rewrite script - Topic 2

echo "*/2 * * * * /usr/local/sysopsonaws-labs-linux-master/MonitoringLab/pollInstances.sh [monitoring_server_url]" | crontab -

## Consume Auto Scaling Events - Topic 2

/usr/local/sysopsonaws-labs-linux-master/MonitoringLab/consumeEvents.sh [queue_url] [monitoring_server_url]
