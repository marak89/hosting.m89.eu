#!/bin/bash
#
# skrypt do backupowania
# Marcin Ral
# marcin@ral.info.pl
# inspiracja http://blog.y3ti.pl/2008/12/backup-mysql-na-szybko/
# data powstania: 2013-11-13
# xxxx-xx-xx zmiana na kopie tylko jednej bazy
# 2017-11-16 Ddoanie usuwania kopii starszych niz tydzien
# 2019-09-19 wykonywanie kopji na podstawie pliku sql.cfg
# marak89.com / m89.eu

if [ -f sql.cfg ]
then
	echo "znaleziono plik z konfiguracja - sql.cfg"
	
# haslo do konta administracyjnego sql, aby zgrac wszystkie bazy danych
DB_USER='admin'
DB_PASS='ekwsdn92qkaw55'

DATE=`date "+%Y_%m_%d_%H_%M_%S"`

WORKINGDIR=`pwd`
TMP_DIR=$WORKINGDIR"/db_$DATE"
echo "Rozpoczecie:  "$DATE > backup_lastrun.txt
echo "Rozpoczynam backup zdefiniowanych baz danych"
echo "Rozpoczecie:  "$DATE
echo "Katalog roboczy: "$WORKINGDIR 
echo "Katalog tymczasowy: "$TMP_DIR 

mkdir -p "db_$DATE"
readarray databases < sql.cfg

for var in "${databases[@]}"
do
  DB_NAME=`echo ${var}|tr '\n' ' '`
  echo "Wykonuje kopie dla bazy danych: "$DB_NAME
  #echo ""
  mysqldump -u $DB_USER -p$DB_PASS  $DB_NAME > `echo $TMP_DIR`/`echo $DB_NAME`.sql 2>`echo $TMP_DIR`/`echo $DB_NAME`.sql.log
  mkdir -p sql
  chmod 700 sql
  cd $TMP_DIR
  tar -cjf ../sql/`echo $DB_NAME`_`echo $DATE`.tar.bz2 *
  cd ../
done

#echo "Remove files older than 7 days in ./sql";
find ./sql -type f -mtime +7 -exec rm -fr {} +
# usuwanie katalogu tymczasowego
rm -r $TMP_DIR
DATEEND=`date "+%Y_%m_%d_%H_%M_%S"`
echo "Zakonczenie:  "$DATEEND >> backup_lastrun.txt
echo "Zakonczenie:  "$DATEEND 
	
else
	echo "Nie odnaleziono pliku z konfiguracja - sql.cfg"
fi
