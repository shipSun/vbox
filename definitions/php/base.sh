# Base install

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

cat > /etc/yum.repos.d/epel.repo << EOM
[epel]
name=epel
baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
enabled=1
gpgcheck=0
EOM

yum -y install gcc* make kernel kernel-devel kernel-headers zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils  man acpid vim-common vim-enhanced ntp cmake

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

chkconfig --level 235 iptables off
