#!/bin/sh
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/sbin/scripts

UTC=yes


#mount -n -t proc proc /proc
#mount -n -t sysfs sysfs /sys
#mount -n -t ramfs ramfs /home
#mount -n -t ramfs ramfs /tmp
#mount -n -t ramfs ramfs /mnt
mount -n -t ramfs ramfs /dev
#mkdir /dev/pts
#mount -t devpts devpts /dev/pts

mount -a
mknod /dev/zero c 1 5

sleep 3

# build var directories
/bin/mkdir -m 0777 /tmp/mnt
/bin/mkdir -m 0777 /tmp/var
/bin/mkdir -m 0777 /tmp/etc
/bin/mkdir -m 0777 /tmp/etc_ro
/bin/mkdir -m 0777 /tmp/dev
/bin/mkdir -m 0777 /var/lock
/bin/mkdir -m 0777 /var/log
/bin/mkdir -m 0777 /var/run
/bin/mkdir -m 0777 /var/tmp
/bin/mkdir -m 0755 /etc/dnrd
/bin/mkdir -m 0777 /mnt/shares
/bin/mkdir -m 0777 /var/run/bftpd
/bin/mkdir -m 0777 /var/run/down
/bin/mkdir -m 0777 /var/run/lock

#/bin/cp -a /usr/dev/* /dev/
/bin/cp -a /usr/etc/* /etc
/bin/cp -a /usr/dev/* /dev
/bin/cp -a /usr/etc_ro/* /etc_ro

# Ralink MT7620 rcS
cat /usr/etc/motd

#nvram_daemon&
#goahead&

#enable FTP server
#/sbin/enable_ftp.sh


mount -t devpts devpts /dev/pts
#for telnet debugging
telnetd

#/sbin/internet.sh


# init reg so that led_hw can work
/sbin/rc reg_init


#for syslogd
mkdir -p /var/log

mknod /dev/fuse c 10 229
# insert modules
#/sbin/insmod /lib/modules/bcm_enet.ko
#/sbin/insmod /lib/modules/vnet.ko
#/sbin/insmod /lib/modules/atmapi.ko
#/sbin/insmod /lib/modules/blaa_dd.ko
#/sbin/insmod /lib/modules/adsldd.ko
#/sbin/insmod /lib/modules/br2684.ko
/sbin/insmod /lib/modules/led_pb_api.ko
/sbin/insmod /lib/modules/led_hw.ko
# LED show we are booting...
#/usr/sbin/led_app off 70 ; /usr/sbin/led_app on 71
/usr/sbin/led_app blink_always 70 5 100 100 0
/sbin/insmod /lib/modules/2.6.30.9/kernel/fs/jbd2/jbd2.ko
/sbin/insmod /lib/modules/2.6.30.9/kernel/fs/ext4/ext4.ko
#/sbin/insmod /lib/modules/sc_blink.ko
#/sbin/insmod /lib/modules/ipt_psd.ko
#/sbin/insmod /lib/modules/ipt_random.ko
#/sbin/insmod /lib/modules/ipt_REJECT.ko
/sbin/insmod /lib/modules/ipt_condition.ko
#/sbin/insmod /lib/modules/ct_mgr.ko
#/sbin/insmod /lib/modules/ipt_PNAT.ko
/sbin/insmod /lib/modules/ipt_http_string.ko
/sbin/insmod /lib/modules/ipt_dnshj.ko
/sbin/insmod /lib/modules/ipt_DLOG.ko
/sbin/insmod /lib/modules/xt_ct_dir.ko

/sbin/insmod /lib/modules/cnapt_core.ko
/sbin/insmod /lib/modules/cnapt.ko
#/sbin/insmod /lib/modules/cui.ko
/sbin/insmod /lib/modules/cpt.ko
/sbin/insmod /lib/modules/cpm.ko
/sbin/insmod /lib/modules/calg.ko
/sbin/insmod /lib/modules/cdmz.ko
/sbin/insmod /lib/modules/cudp.ko
/sbin/insmod /lib/modules/hairpin.ko
/sbin/insmod /lib/modules/natlimit.ko

#add for arp protect, static arp table and reject arp reply from lan PC to DUT
/sbin/insmod /lib/modules/arp_protect_enable.ko 

#insert rtsp alg modules, may need stun arguments later
#/sbin/insmod /lib/modules/nf_conntrack_rtsp.ko
#/sbin/insmod /lib/modules/nf_nat_rtsp.ko

#insert SPI firewall module
/etc/do.sh
# mike add wifi modules
#/sbin/insmod /lib/modules/2.6.22/kernel/drivers/net/emf/emf.ko
#/sbin/insmod /lib/modules/2.6.22/kernel/drivers/net/igs/igs.ko
#/sbin/insmod /lib/modules/2.6.22/kernel/drivers/net/wl/wl.ko
#/sbin/insmod /lib/modules/wifi_statistics.ko

#/usr/sbin/led_app on 70

/bin/echo "insmod finish" > /dev/console
# Add for web slow response


#echo "Start usbdecting ..."
#/sbin/udevstart

#echo "/sbin/udev" > /proc/sys/kernel/hotplug
#/usr/sbin/usbdect &

# for retrain margin the rc.sh is generate in rc/Makefile
#/usr/sbin/rc.sh

# start services


/usr/sbin/brctl addbr br0
/usr/sbin/brctl stp br0 no
/sbin/ifconfig eth2 up
# Use vconfig to simulate LAN and WAN. LAN - 1 WAN - 2
/sbin/vconfig add eth2 1
/sbin/vconfig add eth2 2
/sbin/ifconfig eth2.1 up
/sbin/ifconfig eth2.2 up
/usr/sbin/brctl addif br0 eth2.1

# stamp lan start time
/bin/cp /proc/uptime /tmp/lan_uptime

ifconfig lo 127.0.0.1
route add -net 127.0.0.0 netmask 255.0.0.0 lo

#JIM force to use IGMP v2
#modify to 3 for netgear spec 1.9
echo "3" > /proc/sys/net/ipv4/conf/all/force_igmp_version

#Modify icmp time for netgear spec 1.9
# debug staff
#/usr/sbin/micro_inetd 23 /usr/sbin/utelnetd&

#/usr/sbin/utelnetd -d&
cp -f /usr/sbin/setupwizard.cgi /tmp/setupwizard.cgi
/sbin/klogd&

# Move up by Joel for DG834NR WPA function.
/usr/sbin/cmd_agent_ap
#/usr/sbin/cmd_agent_ap_3g
if [ "1" = "0" ]; then
#/usr/sbin/cmd_agent_ap_3g
# config rtk switch vlan disable
/bin/echo 0 > /proc/rtk_vlan_support

# config rtl as gateway mode
/bin/echo 0 > /proc/sw_nat

#close wan_unknowmac2cpu, only enable this when detecting
/bin/echo 0 > /proc/wan_unknowmac2cpu

fi


#MT7610e 11ac driver
/sbin/insmod /lib/modules/2.6.36/kernel/drivers/net/wireless/MT7610_ap/MT7610_ap.ko

# MT7612e 11ac driver
/sbin/insmod /lib/modules/2.6.36/kernel/drivers/net/wireless/rlt_wifi_ap/rlt_wifi.ko

/usr/sbin/rc init


/usr/sbin/rc wlan start



/bin/echo "=============rc start " > /dev/console
/usr/sbin/rc start
/bin/echo "=============rc finish " > /dev/console

/usr/sbin/scfgmgr &

/bin/ps

# load storage driver late to make system prepare things like nvram done 
# then make usb device plug event happen
/sbin/insmod /lib/modules/2.6.36/kernel/drivers/usb/storage/usb-storage.ko

/usr/sbin/rc upnp start

#/usr/sbin/dproxy -c /etc/resolv.conf&


/usr/sbin/crond &


#/usr/sbin/atm_monitor init
/usr/sbin/multi_pb_app 90 91 92 10 50&

#Ron add for upnpd
route add -net 239.0.0.0 netmask 255.0.0.0 br0
#route add -net 239.0.0.0 netmask 255.0.0.0 br1


#echo "0 0" > /proc/sys/vm/pagetable_cache
# router
echo 1 > /proc/sys/net/ipv4/ip_forward

if [ "1" = "0" ]; then
# pppox
echo 1 > /proc/sys/net/ipv4/ip_dynaddr

#arp ignore
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore

# add more conntrack
echo 4608 > /proc/sys/net/netfilter/nf_conntrack_max

# ignore_all not yet used: this should be satisfactory
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# set to 1 for lan static route, when wan is not up and ip_forward is 0.
echo 1 > /proc/sys/net/ipv4/conf/br0/forwarding
echo 1 > /proc/sys/net/ipv4/conf/wlan0/forwarding
echo 1 > /proc/sys/net/ipv4/conf/wlan0-va0/forwarding

# drop spoofed addr: turn this off when rip is on ?
# turn off for performance when fast_path is enabled
echo 1 > /proc/sys/net/ipv4/conf/eth1/rp_filter
echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
# do not honor source route flags
echo 0 > /proc/sys/net/ipv4/conf/default/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
# this needs proper sampling on av_blog to determine optimal value
# for now just observe softnet_stats to see # time was throttled
# historical value was 300
echo 100 > /proc/sys/net/core/netdev_max_backlog
#Modify icmp time for netgear spec 1.9
echo 300 > /proc/sys/net/ipv4/netfilter/ip_conntrack_generic_timeout
echo 300 > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout_stream
echo 300 > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
echo 60 > /proc/sys/net/ipv4/netfilter/ip_conntrack_icmp_timeout
echo 1800 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established
echo 60 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_syn_sent
#remove session after get 2dirs FIN without timeout
echo 0 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_time_wait
#/usr/sbin/micro_inetd 21 /usr/sbin/ftpd&
fi
#define min linux memory
 echo 4096 > /proc/sys/vm/min_free_kbytes


/usr/sbin/cmd_agent &


#usr/sbin/rc wan start &
#/usr/sbin/rc reset_lan start


# LED show we have boot finished
/usr/sbin/led_app off 71 ; /usr/sbin/led_app on 70
/usr/sbin/led_app off 74

#add 3G prepare device
#/etc/prepare_3g
#if [ ! -e /var/run/rc.choose_wan.run ]; then
#    rc choose_wan start
#fi
sleep 5;
usr/sbin/wan_monitor &


#/sbin/insmod /lib/modules/2.6.36/kernel/drivers/usb/serial/usbserial_filter.ko
#/sbin/insmod /lib/modules/GPL_NetUSB.ko
#/sbin/insmod /lib/modules/NetUSB.ko

/bin/ps

echo 8 > /proc/sys/kernel/printk


#/bin/sh

