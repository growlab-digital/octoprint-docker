# https://github.com/LibreELEC/LibreELEC.tv/pull/3402#issuecomment-480023105

### Dockerfile

```
FROM alpine:latest as build

RUN apk add --update alpine-sdk \
		linux-headers \
		jpeg-dev \
		imagemagick \
		v4l-utils-dev \
		cmake \
		git

WORKDIR /mjpg-streamer

RUN git clone https://github.com/jacksonliam/mjpg-streamer.git . && \
    cd mjpg-streamer-experimental && \
    make

FROM alpine:latest

RUN apk add --no-cache v4l-utils-dev

WORKDIR /mjpg-streamer

COPY --from=build /mjpg-streamer/mjpg-streamer-experimental .

RUN mv _build/plugins/input_uvc/input_uvc.so /usr/lib && \
	mv _build/plugins/output_http/output_http.so /usr/lib && \
	ln -s /mjpg-streamer/mjpg_streamer /usr/bin/mjpg_streamer

EXPOSE 8081

ADD docker-entrypoint.sh /

CMD ["/bin/sh", "/docker-entrypoint.sh"]
```

### /docker-entrypoint.sh

```
#! /bin/sh
# docker-entrypoint.sh

mjpg_streamer -o "output_http.so -w ./www -p 8081" -i "input_uvc.so -d /dev/video0 -q 85 -f 20 -r 640x480"
```

# https://community.octoprint.org/t/setting-up-octoprint-on-a-raspberry-pi-running-raspbian-or-raspberry-pi-os/2337

scripts reference and octopi default behavior

# https://wiki.alpinelinux.org/wiki/How_to_get_regular_stuff_working

alpine helper

# https://www.pybootcamp.com/blog/how-to-write-dockerfile-python-apps/

# https://rollout.io/blog/understanding-dockers-cmd-and-entrypoint-instructions/

# http://supervisord.org/running.html#running-supervisorctl

supervisorctl docs

# https://docs.docker.com/develop/develop-images/baseimages/

# https://www.docker.com/blog/speed-up-your-development-flow-with-these-dockerfile-best-practices/

dockerfile for python

# https://github.com/OctoPrint/octoprint-docker/issues/163

propose .env + docker-compose.override.yml

# https://github.com/janjongboom/alpine-opencv-docker

alpine has only arm opencv binaries, create dependencies (.rpi-deps) for multi-arch building
