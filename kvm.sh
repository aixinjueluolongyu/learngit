#!/bin/sh
ti='/etc/systemd/system/vncserver@:1.service'

systemctl stop firewalld.service
systemctl disable firewalld.service

yum -y groupinstall "X Window System"
yum -y install tcl tk expect gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
unlink /etc/systemd/system/default.target
ln -sf /lib/systemd/system/graphical.target/etc/systemd/system/default.target
yum install tigervnc-server

cp -rf /lib/systemd/system/vncserver@.service $ti
sed -i 's#ExecStart=/usr/sbin/runuser -l <USER> -c#ExecStart=/usr/sbin/runuser -l root -c#g' $ti
sed -i 's#PIDFile=/home/<USER>/.vnc/%H%i.pid#PIDFile=/home/root/.vnc/%H%i.pid#g' $ti
systemctl daemon-reload
./ying.sh
#install kvm
yum -y install qemu-kvm libvirt virt-install bridge-utils libguestfs libguestfs-tools virt-manager libguest* libvirt*
systemctl enable libvirtd
systemctl start libvirtd
systemctl enable vncserver@:1.service
systemctl start vncserver@:1.service 
reboot
