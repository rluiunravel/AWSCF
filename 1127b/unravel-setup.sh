# Download unravel rpm
#/usr/bin/wget http://preview.unraveldata.com/img/unravel-4.2-1061.x86_64.EMR.rpm

# Prepare the VM for unravel rpm install
/usr/bin/yum install -y ntp
/usr/bin/yum install -y libaio
/usr/bin/yum install -y lzop
/usr/bin/systemctl enable ntpd
/usr/bin/systemctl start ntpd
/usr/bin/systemctl disable firewalld
/usr/bin/systemctl stop firewalld

/usr/sbin/iptables -F

/usr/sbin/setenforce 0
sleep 30


# Prepare disk for unravel
mkdir -p /srv

DATADISK=`/usr/bin/lsblk |grep 100G | awk '{print $1}'`
echo "/dev/${DATADISK}1  /srv  ext4 defaults 0 0" >> /etc/fstab

#/usr/sbin/parted -s /dev/${DATADISK} mklabel gpt mkpart primary 0% 100%

echo "Partitioning Disk ${DATADISK}"

#echo -e "o\nn\np\n1\n\n\nw" | fdisk ${DATADISK}


#/usr/sbin/mkfs -t ext4  /dev/${DISKPARD}
#/usr/bin/mount -a

# install unravel rpm
#/usr/bin/rpm  -U unravel-4.2-1061.x86_64.EMR.rpm

#/usr/bin/sleep 15

# Starting Unravel daemons
#/etc/init.d/unravel_all.sh start
