Druid Ansible
===============

This project can setup a druid cluster on AWS

AWS preparations
----------------

Instances:

Instances are automatically created

Storage:

Create a bucket (druidbucket) with the following 3 folders in it:
- logs
- data
- deepstorage

User:

Create a IAM user (druiduser) for accessing the data in S3. Be sure to capture the credentials

Add the following policy to the user

```
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::druidbucket",
                "arn:aws:s3:::druidbucket/*"
            ]
        }
    ]
}
```


AWS ansible playbook variable configuration
in vars/cluster.yml supply the needed ami, vpc, subnet and key filename variables:
```
ami: <ami-id>
main_vpc_id: <vpc-id>
subnet_id_a: <subnet-id-region-a>
subnet_id_b: <subnet-id-region-b>
subnet_id_c: <subnet-id-region-c>
key_name: <druid-key-pem-file>
```

in roles/security-groups/default/main.yml change the external ip range to which the security group will be opened up:
```
ip_range: "192.168.1.0/32"
```

in vars/druid.yml supply the needed s3 variables:

```
deep_storage_type: s3
druid_s3_accessKey: ACCESS_KEY_ID
druid_s3_secretKey: SECRET_KEY
druid_s3_baseKey: deepstorage
druid_s3_bucketname: druidbucket
deep_storage_location: {{ druid_s3_bucketname }}/data
deep_storage_log_location: {{ druid_s3_bucketname }}/logs
``` 

AWS deployment
--------------
ansible-playbook create-druid-cluster.yml
ansible-playbook --user centos --private-key ./druid.pem ping.yml
ansible-playbook --user centos --private-key ./druid.pem java.yml
ansible-playbook --user centos --private-key ./druid.pem playbook.yml
ansible-playbook --user centos --private-key ./druid.pem enable-metrics.yml

Testing
-------
curl -X 'POST' -H 'Content-Type:application/json' -d @index-data.json 34.249.13.4:8081/druid/indexer/v1/task
