#!/bin/bash
# The backup script authored by TADOKORO Saneyuki <saneyan@gfunction.com>

cd $(dirname $0)

# Generate archive name (e.g. 2015-05-29_02:55:35)
function gen-vault-name() {
	date "+%Y-%m-%d_%H-%M-%S"
}

function clean-old() {
	local RET=$(($(ls $1 | wc -w) - $2))

	if test $RET -gt 0; then
		local TARGET="$(ls -tr $1 | head -$RET)"

		if test $RET -gt 1; then
			TARGET="{$(echo $TARGET | sed 's/ /,/g')}"
		fi

		eval "rm -v $1/$TARGET"
	fi
}

case $1 in
	# Clean old archives but keep less than or equal to 20 newer archives.
	'clean-old') clean-old ./backups $MAX_BACKUPS ;;
	# Archive directory as TAR.
	'archive') tar cvf ./backups/$(gen-vault-name).tar $2 ;;
	# Syncronize backup folder with S3 bucket.
	'sync') aws s3 sync ./backups s3://$S3_BUCKET/$S3_DIR --region $AWS_REGION --delete ;;
	'rev-sync') aws s3 sync s3://$S3_BUCKET/$S3_DIR ./backups --region $AWS_REGION --delete ;;
	*) echo 'archive|sync|rev-sync|clean-old' ;;
esac
