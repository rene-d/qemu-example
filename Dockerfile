FROM tianon/qemu:native

RUN apt-get update && apt-get upgrade -qq -y && \
    apt-get install -qq -y --no-install-recommends \
        ca-certificates curl \
        genisoimage iproute2 procps net-tools openssh-client

RUN curl -skL -o /usr/local/bin/cloud-localds https://raw.githubusercontent.com/canonical/cloud-utils/main/bin/cloud-localds && \
    chmod a+x /usr/local/bin/cloud-localds

# Debian Cloud image (http://cloud.debian.org/images/cloud/)
# COPY debian-10-genericcloud-amd64-20210721-710.qcow2 /hda.qcow2
RUN curl -skL -o /hda.qcow2 http://cloud.debian.org/images/cloud/buster/20210721-710/debian-10-genericcloud-amd64-20210721-710.qcow2

# create backing files
RUN qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm1.qcow2
RUN qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm2.qcow2

COPY userdata.txt start.sh /

RUN cloud-localds /debian.iso userdata.txt

# # options for start-qemu script (not used)
# ENV QEMU_HDA=/hda_vm1.qcow2 \
# 	QEMU_HDA_SIZE=100G \
# 	QEMU_CPU=2 \
# 	QEMU_RAM=512 \
# 	QEMU_CDROM=/debian.iso \
# 	QEMU_BOOT='order=c' \
# 	QEMU_PORTS=''

CMD ["/start.sh"]
