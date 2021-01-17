FROM python:3.8-alpine AS compiler

RUN apk add --no-cache --upgrade --virtual .build-deps \
    gcc \
    libc-dev \
    musl-dev \
    libffi-dev \
    make 

RUN apk add --no-cache --upgrade --virtual .rpidev-deps \
    raspberrypi-dev \
    wiringpi-dev \
    py3-rpigpio \
    libgpiod-dev \
    py3-libgpiod \
    linux-tools-gpio

RUN pip install pip --upgrade

RUN adduser -D octoprint
USER octoprint
WORKDIR /home/octoprint

RUN pip install --user --no-cache-dir pip \
    setuptools \
    wheel
ENV PATH /home/octoprint/.local/bin:$PATH
RUN python3 -m venv venv
RUN source venv/bin/activate
RUN pip install --user --no-cache-dir octoprint

USER root
RUN apk del .build-deps && \
    apk del .rpidev-deps

FROM python:3.8-alpine AS runtime

ARG octoprint_ref
ENV octoprint_ref ${octoprint_ref:-master}

RUN adduser -D octoprint && \
    apk add --no-cache --virtual .run-deps \
    tini \
    supervisor \
    --virtual .rpi-deps \
    py3-rpigpio \
    wiringpi \
    raspberrypi && \
    addgroup octoprint tty && \
    addgroup octoprint video && \
    addgroup octoprint dialout

USER octoprint
WORKDIR /home/octoprint

COPY --chown=octoprint:octoprint --from=compiler /home/octoprint /home/octoprint
COPY --chown=octoprint:octoprint ./supervisord.conf /etc/supervisord.conf
ENV PATH /home/octoprint/.local/bin:$PATH

RUN pip install --user supervisor --upgrade --no-cache-dir

EXPOSE 5000

ENTRYPOINT [ "/sbin/tini", "--", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

