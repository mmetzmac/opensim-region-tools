#!/bin/bash
#
# Key things to remember, no spaces in pathnames, and try to use fill paths (beginning with / )
#
# now fill in these few variables for me
# change to use
 
# FTP username and Pass
# FTPUSER=ftpusername
# FTPPASS=ftppassword
 
# this is a list of directories you want backed up. No trailing / needed.
INCLUDES="/home /var/www"
 
# I added a mysql user called backup with permissions to SELECT and LOCKING only for this backup
# CREATE USER backup@'localhost' IDENTIFIED BY 'backuppassword';
# GRANT SELECT,LOCKING ON *.* TO backup@'localhost'  WITH GRANT OPTION;
#
# change this variable to anything but 1 to disable mysql backups ( some prefer to backup the binlog )
MYSQLBACKUP=1
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
/bin/mkdir -p ${TMPDIR}/files &&
/bin/mkdir -p ${TMPDIR}/db &&
/bin/mkdir -p ${TMPDIR}/archives &&
 
if [ $MYSQLBACKUP = 1 ];then
/usr/bin/mysqldump -u${DBUSER} -p${DBPASS} -A | gzip -c > ${TMPDIR}/db/mysql_backup-${DATESTAMP}-${DAYOFWEEK}.sql.gz
fi
 
for ITEMI in ${INCLUDES} ; do
/bin/mkdir -p ${TMPDIR}/files/${ITEMI}/
/usr/bin/rsync -aq ${ITEMI}/* ${TMPDIR}/files/${ITEMI}/
done
 
/bin/tar jcf ${TMPDIR}/archives/file-backup-${DATESTAMP}-${DAYOFWEEK}.tar.bz2 ${TMPDIR}/files/ > /dev/null 2>&1 &&
 
/usr/bin/lftp -u "${FTPUSER},${FTPPASS}" backupspace.rimuhosting.com -e "set ftp:ssl-protect-data true; mrm *-${DAYOFWEEK}.* ; put ${TMPDIR}/archives/file-backup-${DATESTAMP}-${DAYOFWEEK}.tar.bz2; put ${TMPDIR}/db/mysql_backup-${DATESTAMP}-${DAYOFWEEK}.sql ; exit" >/dev/null
 
# remove all older files
#rm -rf ${TMPDIR}/*