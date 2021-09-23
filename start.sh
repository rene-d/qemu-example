#!/bin/bash

# the bridge between the two VM
ip link add br0 type bridge
ip link set up dev br0
ip addr add 10.0.0.1/24 dev br0

start()
{
    local node=$1

    # precreate the tap interfaces
    ./ifup-qemu tap${node}

    # build the cloud-init config
    cloud-localds --network-config=network-config_${node}.yaml /userdata${node}.iso userdata.txt metadata.json

    # create backing files
    rm -f hda_vm${node}.qcow2
    qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm${node}.qcow2

    # vm1: use backing file hda_vm1.img and ssh port 11022
    qemu-system-x86_64 -smp 2 -m 512 \
        -drive file=/hda_vm${node}.qcow2,index=0,media=disk,discard=unmap,detect-zeroes=unmap,if=none,id=hda -device virtio-scsi-pci \
        -device scsi-hd,drive=hda -cdrom /userdata${node}.iso \
        -boot order=c \
        -netdev user,hostname=vm${node},hostfwd=tcp::1${node}022-:22,id=net0 -device virtio-net-pci,netdev=net0 \
        -netdev tap,id=net1,ifname=tap${node},script=/bin/true -device virtio-net-pci,netdev=net1,mac=52:54:00:29:2b:0${node} \
        -nographic > vm${node}.log &
}

start 1
start 2

sleep infinity
