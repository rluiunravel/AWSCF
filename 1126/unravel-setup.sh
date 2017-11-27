!#/bin/bash

/usr/bin/wget http://preview.unraveldata.com/img/unravel-4.2-1061.x86_64.EMR.rpm
/usr/bin/yum install -y ntp
/usr/bin/systemctl enable ntpd
/usr/bin/systemctl start ntpd
/usr/bin/rpm  -U unravel-4.2-1061.x86_64.EMR.rpm
