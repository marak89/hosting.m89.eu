#!/bin/bash
#
# hosting server backup by marak89
# v01 - 19-09-2019
#

DATE=`date "+%Y_%m_%d_%H_%M"`
WWWDIR=/var/www

if [ -n "$1" ]
then
DIRTOBKP=$1
FULLDIRTOBKP=$WWWDIR/$1

if [ -d "$FULLDIRTOBKP" ] 
then

pwd
cd `echo $FULLDIRTOBKP`
pwd
if [ -f ./sql.cfg ]
then
echo "znaleziono plik z konfiguracja SQL - sql.cfg"
	/var/script/backupSql.sh
	else 
echo "NIE znaleziono pliku z konfiguracja SQL - sql.cfg"
fi
cd /var/www
TMPDIR=/tmp/toBackup
mkdir -p $TMPDIR

FILENAME=$TMPDIR/$DIRTOBKP"_"$DATE.tar.bz2
echo "Katalog do skopiowania: " $FULLDIRTOBKP
echo "Plik z kopia: " $FILENAME
echo "Kompresuje..."
tar -cjf $FILENAME $FULLDIRTOBKP
echo "wysylam do bkp@nas.srv:~/hosting"
scp $FILENAME bkp@nas.srv:~/hosting
echo "Usuwam plik "$FILENAME
rm $FILENAME

else
echo "Katalog "$FULLDIRTOBKP" nie istnieje!"
fi

else
echo "Podaj nazwe katalogu jako parametr!"
echo "Przykład: "$0 "wloczka.com"
fi
