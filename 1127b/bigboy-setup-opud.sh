# Prepare the VM for on-premise unravel install
# this VM will have /srv partition of 2TB

/usr/bin/yum install -y ntp
/usr/bin/yum install -y libaio
/usr/bin/yum install -y lzop
/usr/bin/yum install -y wget
/usr/bin/yum install -y unzip
/usr/bin/yum install -y git
/usr/bin/yum install -y dos2unix

/usr/bin/systemctl enable ntpd
/usr/bin/systemctl start ntpd
/usr/bin/systemctl disable firewalld
/usr/bin/systemctl stop firewalld

/usr/sbin/iptables -F
/usr/bin/sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
/usr/sbin/setenforce 0
sleep 30


# Prepare disk 
mkdir -p /srv

DATADISK=`/usr/bin/lsblk |grep 2048G | awk '{print $1}'`
echo $DATADISK > /tmp/datadisk
echo "/dev/${DATADISK}1" > /tmp/dataprap

echo "Partitioning Disk ${DATADISK}"
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATADISK}

DATAPRAP=`cat /tmp/dataprap`
DDISK=`cat /tmp/datadisk`
/usr/sbin/mkfs -t ext4 ${DATAPRAP}

DISKUUID=`/usr/sbin/blkid |grep ext4 |grep $DDISK  | awk '{ print $2}' |sed -e 's/"//g'`
echo "${DISKUUID}    /srv   ext4 defaults  0 0" >> /etc/fstab

/usr/bin/mount -a

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag


