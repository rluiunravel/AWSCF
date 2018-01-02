# Download unravel rpm
# /usr/bin/wget http://preview.unraveldata.com/img/unravel-4.2-1064.x86_64.EMR.rpm

# Prepare the VM for unravel rpm install
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


# Prepare disk for unravel
mkdir -p /data1
mkdir -p /data2
mkdir -p /data3

DATA1DISK=`/usr/bin/lsblk |grep 1001G | awk '{print $1}'`
DATA2DISK=`/usr/bin/lsblk |grep 1002G | awk '{print $1}'`
DATA3DISK=`/usr/bin/lsblk |grep 1003G | awk '{print $1}'`
DATA4DISK=`/usr/bin/lsblk |grep 1004G | awk '{print $1}'`

echo "/dev/${DATA1DISK}1  /data1  ext4 defaults 0 0" >> /etc/fstab
echo "/dev/${DATA2DISK}1  /data2  ext4 defaults 0 0" >> /etc/fstab
echo "/dev/${DATA3DISK}1  /data3  ext4 defaults 0 0" >> /etc/fstab
echo "/dev/${DATA4DISK}1  /tmp    ext4 defaults 0 0" >> /etc/fstab

echo "/dev/${DATA1DISK}1" > /tmp/data1prap
echo "/dev/${DATA2DISK}1" > /tmp/data2prap
echo "/dev/${DATA3DISK}1" > /tmp/data3prap
echo "/dev/${DATA4DISK}1" > /tmp/data4prap

echo "Partitioning Disk ${DATA1DISK}"
echo "Partitioning Disk ${DATA2DISK}"
echo "Partitioning Disk ${DATA3DISK}"
echo "Partitioning Disk ${DATA4DISK}"

echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA1DISK}
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA2DISK}
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA3DISK}
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DATA4DISK}

DATA1PRAP=`cat /tmp/data1prap`
DATA2PRAP=`cat /tmp/data2prap`
DATA3PRAP=`cat /tmp/data3prap`
DATA4PRAP=`cat /tmp/data4prap`

/usr/sbin/mkfs -t ext4 ${DATA1PRAP}
/usr/sbin/mkfs -t ext4 ${DATA2PRAP}
/usr/sbin/mkfs -t ext4 ${DATA3PRAP}
/usr/sbin/mkfs -t ext4 ${DATA4PRAP}

/usr/bin/rm -rf /tmp/*
/usr/bin/rm -rf /tmp/.font-unix
/usr/bin/rm -rf /tmp/.ICE-unix
/usr/bin/rm -rf /tmp/.Test-unix
/usr/bin/rm -rf /tmp/.ICE-unix
/usr/bin/rm -rf /tmp/.XIM-unix

/usr/bin/mount -a


/usr/bin/sleep 5

#/usr/bin/wget --no-check-certificate https://s3.amazonaws.com/unravelrpm/jdk-8u112-linux-x64.rpm

#/usr/bin/yum localinstall -y jdk-8u112-linux-x64.rpm
#echo "export JAVA_HOME=/usr/java/jdk1.8.0_112" >> /etc/profile
#JAVA_HOME=/usr/java/jdk1.8.0_112

#/usr/bin/wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo

#/usr/bin/yum install -y ambari-agent

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag


# Update Unravel Lic Key into the unravel.properties file
# Obtain a valid unravel Lic Key file ; the following is just non working one
#echo "com.unraveldata.lic=1p6ed4s492012j5rb242rq3x3w702z1l455g501z2z4o2o4lo675555u3h" >> /usr/local/unravel/etc/unravel.properties


# Update Azure blob storage account credential in unravel.properties file
# Update and uncomment the following lines to reflect your Azure blob storage account name and keys
# echo "com.unraveldata.hdinsight.storage-account-name-1=fs.azure.account.key.STORAGEACCOUNTNAME.blob.core.windows.net" >> /usr/local/unravel/etc/unravel.properties
# echo "com.unraveldata.hdinsight.primary-access-key=Ondaq2aYMpJf8pCdvtFJ/zARJvMP1DsoFzBKp//4DVQi+hcL5+XsW2XFNI7ppLottPdAi6KwFQ==" >> /usr/local/unravel/etc/unravel.properties
# echo "com.unraveldata.hdinsight.storage-account-name-2=fs.azure.account.key.STORAGEACCOUNTNAME.blob.core.windows.net" >> /usr/local/unravel/etc/unravel.properties
# echo "com.unraveldata.hdinsight.secondary-access-key=aL3MFZ/5hP4k1AZkFZzCmWjgEMqe0o6F33gJZxwfQABLaynxpatWY71YnH35LuTeVm6CP1w==#" >> /usr/local/unravel/etc/unravel.properties

# Starting Unravel daemons
# uncomment below will start unravel daemon automatically but within unravel_all.sh start  will have exit status=1.
# Thus we recommend login to unravel VM and run unravel_all.sh manually
# /etc/init.d/unravel_all.sh start
