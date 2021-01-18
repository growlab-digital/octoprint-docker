FROM alpine:3.12 AS mjpg-streamer-build

RUN apk add --update --no-cache --virtual .mjpg-deps alpine-sdk \
    linux-headers \
    ffmpeg \
    subversion \
    sdl-dev \
    libjpeg-turbo-dev \
    imagemagick \
    v4l-utils-dev \
    libgphoto2-dev \
    cmake \
    make \
    git 

RUN git clone https://github.com/jacksonliam/mjpg-streamer.git && \
    cd mjpg-streamer/mjpg-streamer-experimental && \
    make && \
    make install

RUN apk del .mjpg-deps

FROM alpine:3.12 AS mjpg-streamer

RUN apk add --update --virtual .mjpg-run-deps \
    v4l-utils-libs \
    supervisor \
    tini \
    ffmpeg

COPY --chown=root:root --from=mjpg-streamer-build /mjpg-streamer/mjpg-streamer-experimental usr/local/lib/mjpg-streamer
COPY --chown=root:root ./scripts/run /usr/local/bin/mjpg-streamer
COPY ./supervisord.conf /etc/supervisord.conf

ENV CAMERA_DEV /dev/video0
ENV MJPEG_STREAMER_AUTOSTART true
ENV MJPG_STREAMER_INPUT -n -r 640x480

EXPOSE 8080

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]