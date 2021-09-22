#!/bin/bash

ip link add br0 type bridge
ip link set up dev br0

# generate a random mac address for the qemu nic
macaddr1=$(printf '29:2B:%02X:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
macaddr2=$(printf '29:2B:%02X:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))


rm -f hda_vm1.qcow2 hda_vm2.qcow2
qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm1.qcow2
qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm2.qcow2

cloud-localds /userdata.iso userdata.txt metadata.json


# vm1: use snapshot file hda_vm1.img and port 11022
qemu-system-x86_64 -smp 2 -m 512 \
    -drive file=/hda_vm1.qcow2,index=0,media=disk,discard=unmap,detect-zeroes=unmap,if=none,id=hda -device virtio-scsi-pci \
    -device scsi-hd,drive=hda -cdrom /userdata.iso \
    -boot order=c \
    -netdev user,hostfwd=tcp::11022-:22,id=net0 -device virtio-net-pci,netdev=net0 \
    -netdev tap,id=net1,ifname=tap0,script=./ifup-qemu      -device virtio-net-pci,netdev=net1,mac=$macaddr1 \
     -nographic

# # vm1: use snapshot file hda_vm2.img and port 12022
qemu-system-x86_64 -smp 2 -m 512 \
    -drive file=/hda_vm2.qcow2,index=0,media=disk,discard=unmap,detect-zeroes=unmap,if=none,id=hda -device virtio-scsi-pci \
    -device scsi-hd,drive=hda -cdrom /userdata.iso \
    -boot order=c \
    -netdev user,hostname=vm2,hostfwd=tcp::12022-:22,hostfwd=udp::12022-:22,id=net -device virtio-net-pci,netdev=net \
    -netdev tap,id=net1,ifname=tap1,script=./ifup-qemu      -device e1000,netdev=net1,mac=$macaddr2 \
    -nographic

# sleep infinity
