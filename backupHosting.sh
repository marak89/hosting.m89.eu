#!/bin/bash
echo "Kopiowanie plikow uzytkownikow"
cd /var/www/
for DIR in *
do
  echo "Wykonuje kopie katalogu: " $DIR
  /var/script/backupDir.sh $DIR
done

echo "Kopiowanie ustawien serwera"
tar -cjf /root/etc.tar.bz2 /etc
scp /root/etc.tar.bz2 bkp@nas.srv:~/hosting
rm  /root/etc.tar.bz2
