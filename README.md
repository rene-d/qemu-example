# docker-qemu

Run QEMU inside a Docker container

```shell
docker build -t qemu .
docker run --rm -ti --name qemu -p 11022:11022 -p 12022:12022 --sysctl net.ipv4.ping_group_range='0 2147483647' qemu
```

## Links

- https://github.com/tianon/docker-qemu
- http://cloud.debian.org/images/cloud/
- http://cloudinit.readthedocs.io
- http://qemu.org
