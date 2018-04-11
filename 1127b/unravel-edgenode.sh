#!/bin/bash

apt-get install --assume-yes  wget

## Download and extract the tar ball

wget http://preview.unraveldata.com/unravel/RPM/4.2.7/Azure/unravel-package.tar.gz  -O /usr/local/unravel-package.tar.gz
cd  /usr/local
tar -zxvf unravel-package.tar.gz

## prepare srv folder

adduser --disabled-password --gecos ""  unravel

mkdir -p /srv/unravel
#cd /srv/unravel
mkdir -p /srv/unravel/k_data
mkdir -p /srv/unravel/log_hdfs
mkdir -p /srv/unravel/s_1_data
mkdir -p /srv/unravel/tmp
mkdir -p /srv/unravel/tmp_hdfs
mkdir -p /srv/unravel/zk_1_data
mkdir -p /srv/unravel/zk_2_data
mkdir -p /srv/unravel/zk_3_data

#sudo mkdir k_data  log_hdfs  s_1_data  tmp  tmp_hdfs  zk_1_data  zk_2_data  zk_3_data

chown hdfs:hdfs /srv/unravel/log_hdfs
chown hdfs:hdfs /srv/unravel/tmp_hdfs

chown unravel:unravel /srv/unravel/k_data
chown unravel:unravel /srv/unravel/s_1_data
chown unravel:unravel /srv/unravel/zk_1_data
chown unravel:unravel /srv/unravel/zk_2_data
chown unravel:unravel /srv/unravel/zk_3_data

#sudo chown unravel:unravel k_data s_1_data zk_1_data zk_2_data zk_3_data tmp
mkdir -p /srv/unravel/s_1_data/unravel14810
chown -R unravel:unravel  /srv/unravel/s_1_data/unravel14810

sudo -u unravel sh -c 'echo "1" > /srv/unravel/zk_1_data/myid'
sudo -u unravel sh -c 'echo "2" > /srv/unravel/zk_2_data/myid'
sudo -u unravel sh -c 'echo "3" > /srv/unravel/zk_3_data/myid'

## Install mysql
dpkg --configure -a
echo "mysql-server mysql-server/root_password password UnravelMySQL123" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password UnravelMySQL123" | debconf-set-selections
apt-get install --assume-yes mysql-server

service mysql start

echo "create database unravel_mysql_prod DEFAULT CHARACTER SET utf8; grant all on unravel_mysql_prod.* TO 'unravel'@'%' IDENTIFIED BY 'CDWOM0hO'; use unravel_mysql_prod; source /usr/local/unravel/mysql_scripts/20170920015500.sql; source /usr/local/unravel/mysql_scripts/20171008153000.sql; source /usr/local/unravel/mysql_scripts/20171202224307.sql; source /usr/local/unravel/mysql_scripts/20180118103500.sql;" | mysql -u root -pUnravelMySQL123

## change permission on unravel daemon scripts
chmod -R 755 /usr/local/unravel/init_scripts

## Completed the phase1 setup
echo "All phase 1 processes are completed"
