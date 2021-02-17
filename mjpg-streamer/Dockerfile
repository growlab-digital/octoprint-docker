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
    tini 

COPY --chown=root:root --from=mjpg-streamer-build /mjpg-streamer/mjpg-streamer-experimental /usr/local/lib/mjpg-streamer

ENV CAMERA_DEV /dev/video0
ENV MJPG_STREAMER_INPUT -n -r 640x480

EXPOSE 8080
WORKDIR /usr/local/lib/mjpg-streamer
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD export LD_LIBRARY_PATH=. && \
    ./mjpg_streamer \
    -i "/usr/local/lib/mjpg-streamer/input_uvc.so $MJPG_STREAMER_INPUT -d $CAMERA_DEV" \
    -o "/usr/local/lib/mjpg-streamer/output_http.so -w /usr/local/lib/mjpg-streamer/www/ -p 8080"