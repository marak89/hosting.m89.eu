#!/bin/bash

domena=$1
adresDocelowy=$2
portDocelowy=$3

if [ -z "$adresDocelowy" ]
then
 adresDocelowy="http://192.168.162.249"
fi


if [ -z "$portDocelowy" ]
then
 portDocelowy="80"
fi



if [ -n "$domena" ]
then
 echo "Generowanie certyfikatu dla domeny $domena"

wellKnown="/var/www/well-known/$domena/"
 echo "Sprawdzanie katalogu $wellKnown"
 if [ -d "$wellKnown" ]
 then
  echo "Katalog $wellKnown ISTNIEJE"
  echo "Certyfikat prawdopodobnie utworzony"
 else
  echo "Tworzenie katalogu $wellKnown"
mkdir $wellKnown

nginxConf="server {\n\n"
nginxConf="$nginxConf listen 443;\n\n"
nginxConf="$nginxConf    server_name $domena;\n\n"

nginxConf="$nginxConf    ssl_certificate           /etc/letsencrypt/live/m89.eu/fullchain.pem;\n"
nginxConf="$nginxConf    ssl_certificate_key       /etc/letsencrypt/live/m89.eu/privkey.pem;\n\n"

nginxConf="$nginxConf    #ssl_certificate           /etc/letsencrypt/live/$domena/fullchain.pem;\n"
nginxConf="$nginxConf    #ssl_certificate_key       /etc/letsencrypt/live/$domena/privkey.pem;\n\n"

nginxConf="$nginxConf    ssl on;\n"
nginxConf="$nginxConf    ssl_session_cache  builtin:1000  shared:SSL:10m;\n"
nginxConf="$nginxConf    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;\n"
nginxConf="$nginxConf    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;\n"
nginxConf="$nginxConf    ssl_prefer_server_ciphers on;\n"
nginxConf="$nginxConf    ssl_dhparam /etc/ssl/private/dhparam.pem;\n\n"

nginxConf="$nginxConf    access_log            /var/log/nginx/$domena.access.log;\n\n"

nginxConf="$nginxConf    location /.well-known {\n"
nginxConf="$nginxConf    alias /var/www/well-known/$domena/.well-known/;\n"
nginxConf="$nginxConf    }\n\n"

nginxConf="$nginxConf    location / {\n\n"

nginxConf="$nginxConf      proxy_set_header        Host \$host;\n"
nginxConf="$nginxConf      proxy_set_header        X-Real-IP \$remote_addr;\n"
nginxConf="$nginxConf      proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;\n"
nginxConf="$nginxConf      proxy_set_header        X-Forwarded-Proto \$scheme;\n\n"

nginxConf="$nginxConf      proxy_ssl_session_reuse off;\n\n"

nginxConf="$nginxConf      # Fix the It appears that your reverse proxy set up is broken error.\n"
nginxConf="$nginxConf      proxy_pass          $adresDocelowy:$portDocelowy;\n"
nginxConf="$nginxConf      proxy_read_timeout  90;\n\n"

nginxConf="$nginxConf      proxy_redirect      $adresDocelowy:$portDocelowy https://$domena;\n\n"

nginxConf="$nginxConf  }\n"
nginxConf="$nginxConf  }\n"



echo -e $nginxConf > /etc/nginx/sites-available/100-$domena

ln -s  /etc/nginx/sites-available/100-$domena  /etc/nginx/sites-enabled/

nginx -t

service nginx reload

certbot certonly --webroot -w /var/www/well-known/$domena/ -d $domena


nginxConf="server {\n\n"
nginxConf="$nginxConf listen 443;\n\n"
nginxConf="$nginxConf    server_name $domena;\n\n"

nginxConf="$nginxConf    ssl_certificate           /etc/letsencrypt/live/$domena/fullchain.pem;\n"
nginxConf="$nginxConf    ssl_certificate_key       /etc/letsencrypt/live/$domena/privkey.pem;\n\n"

nginxConf="$nginxConf    ssl on;\n"
nginxConf="$nginxConf    ssl_session_cache  builtin:1000  shared:SSL:10m;\n"
nginxConf="$nginxConf    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;\n"
nginxConf="$nginxConf    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;\n"
nginxConf="$nginxConf    ssl_prefer_server_ciphers on;\n"
nginxConf="$nginxConf    ssl_dhparam /etc/ssl/private/dhparam.pem;\n\n"

nginxConf="$nginxConf    access_log            /var/log/nginx/$domena.access.log;\n\n"

nginxConf="$nginxConf    location /.well-known {\n"
nginxConf="$nginxConf    alias /var/www/well-known/$domena/.well-known/;\n"
nginxConf="$nginxConf    }\n\n"

nginxConf="$nginxConf    location / {\n\n"

nginxConf="$nginxConf      proxy_set_header        Host \$host;\n"
nginxConf="$nginxConf      proxy_set_header        X-Real-IP \$remote_addr;\n"
nginxConf="$nginxConf      proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;\n"
nginxConf="$nginxConf      proxy_set_header        X-Forwarded-Proto \$scheme;\n\n"
nginxConf="$nginxConf     #wss web socket secure fix error 400\n"
nginxConf="$nginxConf     proxy_set_header	Upgrade \$http_upgrade;\n"
nginxConf="$nginxConf     proxy_set_header	Connection "\""Upgrade"\"";\n"
nginxConf="$nginxConf     proxy_http_version	 1.1;\n"

nginxConf="$nginxConf      proxy_ssl_session_reuse off;\n\n"

nginxConf="$nginxConf      # Fix the It appears that your reverse proxy set up is broken error.\n"
nginxConf="$nginxConf      proxy_pass          $adresDocelowy:$portDocelowy;\n"
nginxConf="$nginxConf      proxy_read_timeout  90;\n\n"

nginxConf="$nginxConf      proxy_redirect      $adresDocelowy:$portDocelowy https://$domena;\n\n"

nginxConf="$nginxConf  }\n"
nginxConf="$nginxConf  }\n"



echo -e $nginxConf > /etc/nginx/sites-available/100-$domena

nginx -t

service nginx reload



 fi
else
 echo "Nie podales nazwy domeny jako parametru wywolania skryptu"
fi
