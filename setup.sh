#!/bin/bash
# The setup script authored by TADOKORO Saneyuki <saneyan@gfunction.com>

cd $(dirname $0)

if ! [ -f ~/.aws/credentials ]; then
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF
fi

if ! [ -f /etc/cron.d/backup ]; then
CRON_MINUTE=${CRON_MINUTE:-*}
CRON_HOUR=${CRON_HOUR:-*}
CRON_DOM=${CRON_DOM:-*}
CRON_MONTH=${CRON_MONTH:-*}
CRON_WEEK=${CRON_WEEK:-*}
MAX_BACKUPS=${MAX_BACKUPS:-20}

cat <<EOF > /etc/cron.d/backup
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/src
S3_BUCKET=$S3_BUCKET
S3_DIR=$S3_DIR
AWS_REGION=$AWS_REGION
MAX_BACKUPS=$MAX_BACKUPS

# m h dom mon dow user	command
$CRON_MINUTE $CRON_HOUR $CRON_DOM $CRON_MONTH $CRON_WEEK root backup.sh archive $BACKUP_TARGET && backup.sh clean-old && backup.sh sync
#
EOF
fi

/src/backup.sh rev-sync

cron && tail -f /var/log/cron.log
