# Download unravel rpm
#/usr/bin/wget http://preview.unraveldata.com/img/unravel-4.2-1061.x86_64.EMR.rpm

# Prepare the VM for unravel rpm install
/usr/bin/yum install -y ntp
/usr/bin/yum install -y libaio
/usr/bin/yum install -y lzop
/usr/bin/systemctl enable ntpd
/usr/bin/systemctl start ntpd
/usr/bin/setenforce 0

# Prepare disk for unravel
do_partition() {
# This function creates one (1) primary partition on the
# disk, using all available space
    DISK=${1}
    echo "n
p
1


w"| fdisk "${DISK}" > /dev/null 2>&1

#
# Use the bash-specific $PIPESTATUS to ensure we get the correct exit code
# from fdisk and not from echo
if [ ${PIPESTATUS[1]} -ne 0 ];
then
    echo "An error occurred partitioning ${DISK}" >&2
    echo "I cannot continue" >&2
    exit 2
fi
}


DATADISK=`/usr/bin/lsblk |grep 100G | awk '{print $1}'`
echo $DATADISK > /tmp/datadisk

#/usr/sbin/parted -s /dev/${DATADISK} mklabel gpt mkpart primary 0% 100%

echo "Partitioning Disk ${DATADISK}"
do_partition $DATADISK


DISKP=`/usr/bin/cat /tmp/datadisk`
DISKPARD=${DISKP}1

#/usr/sbin/mkfs -t ext4  /dev/${DISKPARD}
mkdir -p /srv
echo "/dev/${DISKPARD}  /srv  ext4 defaults 0 0" >> /etc/fstab
/usr/bin/mount -a

# install unravel rpm
#/usr/bin/rpm  -U unravel-4.2-1061.x86_64.EMR.rpm

#/usr/bin/sleep 15

# Starting Unravel daemons
#/etc/init.d/unravel_all.sh start
