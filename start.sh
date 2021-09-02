#!/bin/bash

# vm1: use snapshot file hda_vm1.img and port 11022
qemu-system-x86_64 -smp 2 -m 512 \
    -drive file=/hda_vm1.qcow2,index=0,media=disk,discard=unmap,detect-zeroes=unmap,if=none,id=hda -device virtio-scsi-pci \
    -device scsi-hd,drive=hda -cdrom /debian.iso \
    -boot order=c \
    -netdev user,hostname=vm2,hostfwd=tcp::11022-:22,hostfwd=udp::11022-:22,id=net -device virtio-net-pci,netdev=net \
    -nographic &

# vm1: use snapshot file hda_vm2.img and port 12022
qemu-system-x86_64 -smp 2 -m 512 \
    -drive file=/hda_vm2.qcow2,index=0,media=disk,discard=unmap,detect-zeroes=unmap,if=none,id=hda -device virtio-scsi-pci \
    -device scsi-hd,drive=hda -cdrom /debian.iso \
    -boot order=c \
    -netdev user,hostname=vm2,hostfwd=tcp::12022-:22,hostfwd=udp::12022-:22,id=net -device virtio-net-pci,netdev=net \
    -nographic &

sleep infinity
