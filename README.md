# docker-qemu

Run QEMU inside a Docker container

```text
┏━━━━━━━━━━━━━━━━━━━━━━[ container ]━━━━━━━━━━━━━━━━━━━━━┓
┃                                                        ┃
┃                                                        ┃
┃  ┌────────[ vm1 ]────────┑  ┌────────[ vm2 ]────────┐  ┃
┃  │                       │  │                       │  ┃
┃  │                       │  │                       │  ┃
┃  │ 10.0.2.15   10.0.0.11 │  │ 10.0.0.12   10.0.2.15 │  ┃
┃  │    ens4       net0    │  │    net0         ens4  │  ┃
┃  └─────┬──────────┬──────┘  └─────┬────────────┬────┘  ┃
┃        │          │               │            │       ┃
┃        │          └─ 10.0.0.0/24 ─┘            │       ┃
┃        │                                       │       ┃
┗━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┷───────┛
     ssh 11022                               ssh 12022
```

Container is Debian based with QEMU installed.

VM are Debian generic cloud images.

## Links

- http://qemu.org
- http://cloudinit.readthedocs.io
- http://cloud.debian.org/images/cloud/
- https://github.com/tianon/docker-qemu
