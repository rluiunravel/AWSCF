#!/bin/bash

/usr/bin/yum install -y ntp
/usr/bin/yum install -y libaio
/usr/bin/yum install -y lzop
/usr/bin/yum install -y wget
/usr/bin/yum install -y unzip
/usr/bin/yum install -y git
/usr/bin/yum install -y dos2unix
/usr/bin/yum install -y java-1.8.0-openjdk.x86_64
/usr/bin/yum install -y java-1.8.0-openjdk-devel.x86_64

/usr/bin/systemctl enable ntpd
/usr/bin/systemctl start ntpd
/usr/bin/systemctl disable firewalld
/usr/bin/systemctl stop firewalld

/usr/sbin/iptables -F
/usr/bin/sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
/usr/sbin/setenforce 0
sleep 30


# Prepare data disk partiions

mkdir -p /data1
mkdir -p /data2
mkdir -p /data3
mkdir -p /data4

DATA1DISK=`/usr/bin/lsblk |grep 1001G | awk '{print $1}'`
DATA2DISK=`/usr/bin/lsblk |grep 1002G | awk '{print $1}'`
DATA3DISK=`/usr/bin/lsblk |grep 1003G | awk '{print $1}'`
DATA4DISK=`/usr/bin/lsblk |grep 1004G | awk '{print $1}'`

echo ${DATA1DISK} > /tmp/data1disk
echo ${DATA2DISK} > /tmp/data2disk
echo ${DATA3DISK} > /tmp/data3disk
echo ${DATA4DISK} > /tmp/data4disk

echo "/dev/${DATA1DISK}1"  > /tmp/data1prap
echo "/dev/${DATA2DISK}1"  > /tmp/data2prap
echo "/dev/${DATA3DISK}1"  > /tmp/data3prap
echo "/dev/${DATA4DISK}1"  > /tmp/data4prap

echo "Partitioning Disk ${DATA1DISK}"
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA1DISK}

echo "Partitioning Disk ${DATA2DISK}"
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA2DISK}

echo "Partitioning Disk ${DATA3DISK}"
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA3DISK}

echo "Partitioning Disk ${DATA4DISK}"
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA4DISK}

DATA1PRAP=`cat /tmp/data1prap`
DATA2PRAP=`cat /tmp/data2prap`
DATA3PRAP=`cat /tmp/data3prap`
DATA4PRAP=`cat /tmp/data4prap`

DDISK1=`cat /tmp/data1disk`
DDISK2=`cat /tmp/data2disk`
DDISK3=`cat /tmp/data3disk`
DDISK4=`cat /tmp/data4disk`

/usr/sbin/mkfs -t ext4 ${DATA1PRAP}
/usr/sbin/mkfs -t ext4 ${DATA2PRAP}
/usr/sbin/mkfs -t ext4 ${DATA3PRAP}
/usr/sbin/mkfs -t ext4 ${DATA4PRAP}

DISK1UUID=`/usr/sbin/blkid |grep ext4 |grep $DDISK1  | awk '{ print $2}' |sed -e 's/"//g'`
DISK2UUID=`/usr/sbin/blkid |grep ext4 |grep $DDISK2  | awk '{ print $2}' |sed -e 's/"//g'`
DISK3UUID=`/usr/sbin/blkid |grep ext4 |grep $DDISK3  | awk '{ print $2}' |sed -e 's/"//g'`
DISK4UUID=`/usr/sbin/blkid |grep ext4 |grep $DDISK4  | awk '{ print $2}' |sed -e 's/"//g'`

echo "${DISK1UUID}    /data1   ext4 defaults  0 0" >> /etc/fstab
echo "${DISK2UUID}    /data2   ext4 defaults  0 0" >> /etc/fstab
echo "${DISK3UUID}    /data3   ext4 defaults  0 0" >> /etc/fstab
echo "${DISK4UUID}    /data4   ext4 defaults  0 0" >> /etc/fstab

/usr/bin/mount -a


# Prepare swap partition
SWAPDISK=`/usr/bin/lsblk |grep 96G | awk '{print $1}'`
echo $SWAPDISK > /tmp/swapdisk
echo "/dev/${SWAPDISK}1" > /tmp/swapprap

echo "Partitioning Disk ${SWAPDISK}"
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${SWAPDISK}

SWAPPRAP=`cat /tmp/swapprap`
SDISK=`cat /tmp/swapdisk`

/usr/sbin/mkswap  ${SWAPPRAP}

SWAPDISKUUID=`/usr/sbin/blkid |grep swap |grep $SDISK  | awk '{ print $2}' |sed -e 's/"//g'`
echo "${SWAPDISKUUID}   swap   swap   defaults  0 0" >> /etc/fstab

/usr/sbin/swapon -a

# System settings for CDH and HDP cluster

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
sysctl -w vm.swappiness=10 

#HOSTN=`hostname -s`
#IIP=`/usr/sbin/ifconfig eth0 |grep inet |grep -iv inet6 |awk '{ print $2 }'`
#/usr/bin/hostnamectl set-hostname $HOSTN --static
#echo "${IIP}    ${HOSTN}" >> /etc/hosts
