# docker-s3-backup

Backing up volume data to Amazon S3 bucket.

### Build

Build a docker image from Dockerfile.

```
docker build -t seginus/docker-s3-backup .
```

### Run with volume containers

Run docker-s3-backup with setting environment variables and linking volumes.

Example:
```
docker run -it -d \
  --volumes-from docker-mongodb-data \
  --name docker-s3-backup-mongodb \
  -e "AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxx" \
  -e "AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  -e "S3_BUCKET=seginus-backup" \
  -e "S3_DIR=backup" \
  -e "AWS_REGION=ap-northeast-1" \
  -e "BACKUP_TARGET=/var/lib/mongodb" \
  -e "CRON_MINUTE=30" \
  -e "CRON_HOUR=10" \
  seginus/docker-s3-backup
```

### Environment variables

These variables are required to set up docker-s3-backup.

 * `AWS_ACCESS_KEY_ID`: AWS access key ID
 * `AWS_SECRET_ACCESS_KEY`: AWS secret access key
 * `S3_BUCKET`: Bucket name
 * `S3_DIR`: Bucket folder name
 * `AWS_REGION`: AWS region
 * `BACKUP_TARGET`: Backup target file or directory

These cron variables are optional. The default value is `*`.

 * `CRON_MINUTES`: Specify between 0-59
 * `CRON_HOUR`: Specify between 0-23
 * `CRON_DAY`: Specify between 1-31
 * `CRON_MONTH`: Specify between 1-12 or name
 * `CRON_WEEK`: Specify between 0-7 or name

You can also define max backup count.

 * `MAX_BACKUPS`: The default value is `20`
