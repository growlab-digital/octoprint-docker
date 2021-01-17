FROM python:3.8-alpine AS compiler

ARG octoprint_ref
ENV octoprint_ref ${octoprint_ref}

RUN apk add --no-cache --upgrade --virtual .build-deps \
    gcc \
    libc-dev \
    musl-dev \
    libffi-dev \
    make 

RUN if $platforms == arm64 ; then \
    apk add --no-cache --upgrade --virtual .rpidev-deps \
    raspberrypi-dev \
    wiringpi-dev \
    # py3-rpigpio \
    libgpiod-dev \
    py3-libgpiod \
    linux-tools-gpio; else continue; fi

RUN adduser -D octoprint
USER octoprint
WORKDIR /home/octoprint

RUN pip install --user --no-cache-dir pip \
    setuptools \
    wheel
ENV PATH /home/octoprint/.local/bin:$PATH
RUN python3 -m venv venv
RUN source venv/bin/activate
RUN pip install --user --no-cache-dir octoprint==${octoprint_ref}

USER root
RUN apk del .build-deps && \
    if [ "$platforms" == "arm64" ]; then apk del .rpidev-deps; else continue; fi

FROM python:3.8-alpine AS runtime

RUN adduser -D octoprint && \
    apk add --no-cache --virtual .run-deps \
    tini \
    supervisor

RUN if [ "$platforms" == "arm64"] ; then \
    apk add --no-cache --virtual .rpi-deps \
    # py3-rpigpio \
    wiringpi \
    raspberrypi; else continue; fi && \
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

