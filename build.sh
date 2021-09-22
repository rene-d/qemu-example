#!/usr/bin/env bash

if [[ ! -f id_rsa.cloud ]]; then
    ssh-keygen -t rsa -N "" -f id_rsa.cloud
fi

if [[ -f metadata.json ]]; then
    printf '{"ssh_pubkey":"%s"}' "$(< id_rsa.cloud.pub)" > metadata.json
fi

docker build -t qemu .

docker run --rm -ti --name qemu --device /dev/net --cap-add NET_ADMIN -p 11022:11022 -p 12022:12022 qemu
