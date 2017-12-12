#!/bin/bash -e
# You need to install the AWS Command Line Interface from http://aws.amazon.com/cli/
export VPCID=$(aws ec2 describe-vpcs --filter "Name=isDefault, Values=true" --query "Vpcs[0].VpcId" --output text)
export SUBNETID=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPCID" --query "Subnets[0].SubnetId" --output text)
export SGID=$(aws ec2 create-security-group --group-name lvmpdsecuritygroup --description "LVMPD Postgres Security Group" --vpc-id $VPCID --output text)
aws ec2 authorize-security-group-ingress --group-id $SGID --protocol tcp --port 5432 --cidr 0.0.0.0/0

export INSTANCEID=$(aws rds create-db-instance \
    --db-name lvmetro \
    --vpc-security-group-ids $SGID \
    --db-instance-identifier lvmetro \
    --allocated-storage 40 \
    --db-instance-class db.t2.small \
    --engine postgres \
    --master-username acohen \
    --master-user-password $PGPASSWORD \
--query "DBInstance.DBInstanceIdentifier" --output text)

echo "waiting for $INSTANCEID ..."

aws rds wait db-instance-available --db-instance-identifier $INSTANCEID

export ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier $INSTANCEID --query "DBInstances[0].Endpoint.Address" --output text)

echo "$INSTANCEID is available and listening on $ENDPOINT"

echo "Type 'terminate' to shut down and delete the database."

function terminate() {
                      aws rds delete-db-instance --db-instance-identifier $INSTANCEID --skip-final-snapshot;
                      echo "terminating $INSTANCEID ...";
                      aws rds wait db-instance-deleted --db-instance-identifier $INSTANCEID;
                      aws ec2 delete-security-group --group-id $SGID;
                      echo $INSTANCEID terminated
}

export -f terminate

exec $SHELL -i
