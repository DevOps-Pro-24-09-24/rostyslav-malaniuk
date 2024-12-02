#!/bin/bash

BACKUP_DIR="/backups"
DATE=$(date +%F)
DB_NAME="your_database"
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"

S3_BUCKET=$(aws ssm get-parameter --name "/your/parameter/store" --query "Parameter.Value" --output text)
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"

PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USER $DB_NAME | gzip > $BACKUP_FILE

aws s3 cp $BACKUP_FILE s3://$S3_BUCKET/

aws s3 ls s3://$S3_BUCKET/ | sort | head -n -7 | awk '{print $4}' | while read -r backup; do
  aws s3 rm s3://$S3_BUCKET/$backup
done
