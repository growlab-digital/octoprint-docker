# octoprint-docker

##### This is repo is a sample for running OctoPrint in docker swarm mode + compose using the benefits of a microservice approach, provided by **Traefik** as Service Router (reverse-proxy), **Octoprint** (with ffmpeg!), **mjpg-streamer** and **OctoFarm**. All images are based on Alpine Linux. This stack weights less than **1 Gb** and is optimized to run multiple instances in low powered SBCs (as RPi v1.2 from 2014).

## Setup & running

Generate self-signed certificates with OpenSSL using the script provided:

```
mkdir certs \
&& ./scripts/cert.sh print.3d

```

Then build OctoPrint + mjpg-streamer:
`make build`

You are now able to deploy the stack:

```
make stack-up
```

See in action!

[Traefik Dashboard](https://traefik.print.3d/)

[mjpg-streamer](https://cam.print.3d/)

[OctoPrint](https://print.3d/)

[OctoFarm](https://farm.print.3d/)

## OctoPrint configuration guide

### Webcam & Timelapse:

- Stream URL: `http://cam.print.3d/?action=stream`

- Snapshot URL: `http://mjpg-streamer:8080/?action=snapshot`

- Path to FFMPEG: `/usr/bin/ffmpeg`

### Server

- Restart Octoprint: `supervisorctl restart octoprint`
- Restart system: `supervisorctl update all`
- Shutdown system: `supervisorctl signal SIGTERM all`

**Notice that it will only manage the octoprint instance! All others containers won't be affected!**

To properly stop all services, use `make stack-down`
