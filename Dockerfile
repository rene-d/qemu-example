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
RUN curl -skL -o /hda.qcow2 http://cloud.debian.org/images/cloud/buster/20210721-710/debian-10-genericcloud-amd64-20210721-710.qcow2
# RUN curl -skL -o /hda.qcow2 http://cloud.debian.org/images/cloud/buster/20210721-710/debian-10-nocloud-amd64-20210721-710.qcow2

# set up ssh
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh
COPY ssh_config /root/.ssh/config
COPY id_rsa.cloud /root/.ssh/id_rsa
COPY id_rsa.cloud.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/config /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub

# set up cloud-init
WORKDIR /root
COPY userdata.txt start.sh ifup-qemu metadata.json network-config*.yaml ./

RUN echo "alias ll='ls --color=auto -l'" >> /root/.bashrc

CMD /bin/bash
