# Docker Bazarr

Provide a simple docker image for [`bazarr`].

[`bazarr`]: https://github.com/morpheus65535/bazarr

The goal is to provide a simpler docker image that don't package a bootstrap script like [`linuxserver/bazarr`] to be used on `docker-compose` & `k8s`.

[`linuxserver/bazarr`]: https://github.com/linuxserver/docker-bazarr

The image is provided at <https://hub.docker.com/r/firelightflagbot/bazarr>

## Quick start

Here is a simple `docker-compose` file:

```yaml
services:
  bazarr:
    image: firelightflagbot/bazarr:1.4.3
    user: 1234:1234 # This is the default uid/gid, you can change it.
    ports:
      - 6767:6767
    volumes:
      - type: bind
        source: /somewhere/bazarr-config # The folder need to be owned by the set'd user in `services.bazarr.user` (bazarr need to be able to write to it).
        target: /config
```
