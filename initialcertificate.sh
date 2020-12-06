cp nginx.conf .nginx.conf
( head nginx.conf -n 13; echo } ) > .nginx.conf.tmp
mv .nginx.conf.tmp nginx.conf

docker-compose build nginx
docker-compose up nginx -d

docker pull certbot/certbot
sudo echo waiting 30 seconds for webserver...
sleep 30
sudo bash .generate_cert.bash

cp .nginx.conf nginx.conf
rm .nginx.conf
