#!/bin/sh
backup_dir="backup-$(date +'%Y%m%d%H%M%S')"
echo "$backup_dir"
influx backup --host=$BACKUP_HOST --token=$BACKUP_TOKEN "./$backup_dir"
tar -cvzf - "./$backup_dir" | gpg -c --batch --passphrase "$BACKUP_PASSWORD" > "$backup_dir.tar.gz.gpg"
rm -rf "./$backup_dir"
aws s3 cp "./$backup_dir.tar.gz.gpg" "s3://$BACKUP_BUCKET/influxb_backup/$backup_dir.tar.gz.gpg" --expires 2025-03-14T20:30:00Z