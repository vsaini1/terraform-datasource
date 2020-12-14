#To fetch resource data in general or resources previosley build by other pipelines and using it.
#To just simply apply bucket policy to existing S3 myanybucket

data "aws_s3_bucket" "mybucket {
        bucket = "myanybucket"
}


resource "aws_s3_bucket_policy" "b" {
  bucket = data.aws_s3_bucket.mybucket.bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "{data.aws_s3_bucket.mybucket.bucket.arn}/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}

output "bucketname" {
        value = data.aws_s3_bucket.mybucket.bucket
}
=========================
#The following example shows using an existing Security Group id as a variable and use this data source to obtain the data necessary to create a subnet.

variable "security_group_id" {App1SG}

data "aws_security_group" "selected" {
  id = var.security_group_id
}

resource "aws_subnet" "subnet" {
  vpc_id     = data.aws_security_group.selected.vpc_id
  cidr_block = "10.0.1.0/24"
}

output "vpcidname" {
         value = data.aws_security_group.selected.vpc_id
}
----------------------
#Use filtered data source to get information about an EBS volume for use in other resources.

#Example Usage
data "aws_ebs_volume" "ebs_volume" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "tag:Name"
    values = ["Example"]
  }
}

output "filterdebsvols" {
         value = data.aws_ebs_volume.ebs_volume
}
-----------------------------------------------------
