FROM debian:sid

RUN apt-get update && apt-get upgrade -qq -y && \
    apt-get install -qq -y --no-install-recommends \
    ca-certificates curl \
    genisoimage iproute2 procps net-tools openssh-client \
    procps bridge-utils iputils-ping qemu-utils qemu-system \
    vim tcpdump

RUN curl -skL -o /usr/local/bin/cloud-localds https://raw.githubusercontent.com/canonical/cloud-utils/main/bin/cloud-localds && \
    chmod a+x /usr/local/bin/cloud-localds

# Debian Cloud image (http://cloud.debian.org/images/cloud/)
# COPY debian-10-genericcloud-amd64-20210721-710.qcow2 /hda.qcow2
# RUN curl -skL -o /hda.qcow2 http://cloud.debian.org/images/cloud/buster/20210721-710/debian-10-generic-amd64-20210721-710.qcow2
# RUN curl -skL -o /hda.qcow2 http://cloud.debian.org/images/cloud/buster/20210721-710/debian-10-genericcloud-amd64-20210721-710.qcow2
RUN curl -skL -o /hda.qcow2 http://cloud.debian.org/images/cloud/buster/20210721-710/debian-10-nocloud-amd64-20210721-710.qcow2

# create backing files
RUN qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm1.qcow2
RUN qemu-img create -f qcow2 -b /hda.qcow2 -F qcow2 /hda_vm2.qcow2

COPY id_rsa.cloud /root/.ssh/id_rsa
COPY id_rsa.cloud.pub /root/.ssh/id_rsa.pub
COPY userdata.txt start.sh ifup-qemu metadata.json /

RUN cloud-localds /userdata.iso userdata.txt metadata.json

RUN echo "alias ll='ls --color=auto -l'" >> /root/.bashrc

CMD /bin/bash