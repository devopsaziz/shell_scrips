#!/bin/bash
#This script will list all the resources in the AWS account
#Author : Azfar Aziz
#version: v1.1
#
#Supported services by the script
# 1. EC2
# 2. S3
# 3. RDS
# 4. DynamoDB
# 5. Lambda
# 6. IAM
# 7. CloudFormation
# 8. CloudWatch
# 9. Route53
# 10. VPC
# 11. ELB
# 12. EBS
# 13. EFS
# 14. SNS
# 15. SQS
# 16. CloudTrail
# usage: ./aws_resource_list.sh us-east-1 EC2
# Example: ./aws_resource_list.sh us-east-1 EC2
#####################################################
# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <region> <service>"
    exit 1
fi
# Set the region and service variables
region=$1
service=$2
# Set the AWS CLI profile name
profile_name="default"
# Check if the AWS CLI is installed 
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi
# Check if the AWS CLI is configured
if ! -d ~/.aws/; then
    echo "AWS CLI is not configured. Please configure it and try again."
    exit 1
fi
# Execute the AWS CLI command based on the service name
case $service in
    "EC2")
        echo "Listing EC2 instances in region $region"
        aws ec2 describe-instances --region $region --profile $profile_name --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress]' --output table
        ;;
    "S3")
        echo "Listing S3 buckets in region $region"
        aws s3api list-buckets --query 'Buckets[*].Name' --output table --profile $profile_name
        ;;
    "RDS")
        echo "Listing RDS instances in region $region"
        aws rds describe-db-instances --region $region --profile $profile_name --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus,Endpoint.Address]' --output table
        ;;
    "DynamoDB")
        echo "Listing DynamoDB tables in region $region"
        aws dynamodb list-tables --region $region --profile $profile_name --query 'TableNames' --output table
        ;;
    "Lambda")
        echo "Listing Lambda functions in region $region"
        aws lambda list-functions --region $region --profile $profile_name --query 'Functions[*].[FunctionName,Runtime,Role,Handler,LastModified]' --output table
        ;;
    "IAM")
        echo "Listing IAM users in region $region"
        aws iam list-users --query 'Users[*].[UserName,CreateDate]' --output table --profile $profile_name
        ;;
    "CloudFormation")
        echo "Listing CloudFormation stacks in region $region"
        aws cloudformation describe-stacks --region $region --profile $profile_name --query 'Stacks[*].[StackName,StackStatus,CreationTime]' --output table
        ;;
    "CloudWatch")
        echo "Listing CloudWatch alarms in region $region"
        aws cloudwatch describe-alarms --region $region --profile $profile_name --query 'MetricAlarms[*].[AlarmName,StateValue,MetricName,Namespace]' --output table
        ;;
    "Route53")
        echo "Listing Route53 hosted zones in region $region"
        aws route53 list-hosted-zones --query 'HostedZones[*].[Id,Name,CallerReference]' --output table
        ;;
    "VPC")
        echo "Listing VPCs in region $region"
        aws ec2 describe-vpcs --region $region --profile $profile_name --query 'Vpcs[*].[VpcId,CidrBlock,State]' --output table
        ;;
    "ELB")
        echo "Listing ELB load balancers in region $region"
        aws elbv2 describe-load-balancers --region $region --profile $profile_name --query 'LoadBalancers[*].[LoadBalancerName,State.Code,Type,Scheme]' --output table
        ;;
    "EBS")
        echo "Listing EBS volumes in region $region"
        aws ec2 describe-volumes --region $region --profile $profile_name --query 'Volumes[*].[VolumeId,Size,State,VolumeType]' --output table
        ;;
    "EFS")
        echo "Listing EFS file systems in region $region"
        aws efs describe-file-systems --region $region --profile $profile_name --query 'FileSystems[*].[FileSystemId,CreationToken,LifeCycleState]' --output table
        ;;
    "SNS")
        echo "Listing SNS topics in region $region"
        aws sns list-topics --region $region --profile $profile_name --query 'Topics[*].[TopicArn]' --output table
        ;;
    "SQS")
        echo "Listing SQS queues in region $region"
        aws sqs list-queues --region $region --profile $profile_name --query 'QueueUrls' --output table
        ;;
    "CloudTrail")
        echo "Listing CloudTrail trails in region $region"
        aws cloudtrail describe-trails --region $region --profile $profile_name --query 'trailList[*].[Name,HomeRegion,Status]' --output table
        ;;
    *)
        echo "Invalid service name. Supported services are: EC2, S3, RDS, DynamoDB, Lambda, IAM, CloudFormation, CloudWatch, Route53, VPC, ELB, EBS, EFS, SNS, SQS, CloudTrail"
        exit 1
        ;;
esac
# Check if the command was successful
if [ $? -ne 0 ]; then
    echo "Failed to list resources for service $service in region $region"
    exit 1
fi
# Print a success message
echo "Successfully listed resources for service $service in region $region" 