#!/bin/bash
if ! grep -q "deb http://deb.debian.org/debian buster-backports main" /etc/apt/sources.list; then
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
fi
apt update
apt upgrade -y
apt install -y apache2 python openssh-server vsftpd
systemctl start apache2
systemctl start sshd
systemctl enable sshd
systemctl start vsftpd
mv /etc/vsftpd.conf /etc/vsftpd.conf.orig
echo "anonymous_enable = NO
local_enable = YES
write_enable = YES
local_umask = 022
xferlog_enable = YES
xferlog_std_format=YES
connect_from_port_20 = YES
chroot_local_user = YES
allow_writeable_chroot = YES
ssl_enable=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
rsa_cert_file=/etc/ssl/private/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_ciphers=HIGH
use_localtime=YES" > /etc/vsftpd.conf
systemctl restart vsftpd
useradd -m test-user
echo "1qazXSW@" | passwd --stdin test-user