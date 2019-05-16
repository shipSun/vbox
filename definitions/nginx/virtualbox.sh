# Installing the virtualbox guest additions

VBOX_VERSION=$(cat /home/root/.vbox_version)
cd /tmp
mount -o loop /home/root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/root/VBoxGuestAdditions_*.iso

