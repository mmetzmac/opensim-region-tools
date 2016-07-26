#!/bin/bash
#Key things to remember, no spaces in pathnames, and try to use fill paths (beginning with / )
#
# now fill in these few variables for me
# change to use

# FTP username and Pass
# FTPUSER=ftpusername
# FTPPASS=ftppassword

# this is a list of directories you want backed up. No trailing / needed.
INCLUDES="/srv/backup/oar"

# I added a mysql user called backup with permissions to SELECT and LOCKING only for this backup
# CREATE USER backup@'localhost' IDENTIFIED BY 'backuppassword';
# GRANT SELECT,LOCKING ON *.* TO backup@'localhost'  WITH GRANT OPTION;
#
# change this variable to anything but 1 to disable mysql backups ( some prefer to backup the binlog )
MYSQLBACKUP=0
DBUSER=backup
DBPASS=backuppassword

# this stuff is probably not needing to be changed
TMPDIR=/tmp/backup
DAYOFWEEK=`date +%a`
DATESTAMP=`date +%d%m%y`
cd /
# remove all older files
rm -rf ${TMPDIR}/*

# create directory structure
mkdir -p ${TMPDIR}/files &&
mkdir -p ${TMPDIR}/db &&
mkdir -p ${TMPDIR}/archives &&

if [ $MYSQLBACKUP = 1 ];then
mysqldump -u${DBUSER} -p${DBPASS} -A | gzip -c > ${TMPDIR}/db/mysql_backup-${DATESTAMP}-${DAYOFWEEK}.sql.gz
fi

for ITEMI in ${INCLUDES} ; do
mkdir -p ${TMPDIR}/files/${ITEMI}/
rsync -aq ${ITEMI}/* ${TMPDIR}/files/${ITEMI}/
done

zip -r ${TMPDIR}/archives/oar-${DATESTAMP}-${DAYOFWEEK}.zip ${TMPDIR}/files/
echo "... now starting sftp transfer."
sftp u118467@u118467.your-storagebox.de <<EOF
cd amu
cd oar
put ${TMPDIR}/archives/oar-${DATESTAMP}-${DAYOFWEEK}.zip
quit >/dev/null
EOF
# remove all older files
rm -rf ${TMPDIR}/*
rm /srv/backup/oar/*