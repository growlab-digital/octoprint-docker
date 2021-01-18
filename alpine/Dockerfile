FROM python:3.8-alpine AS compiler

ARG octoprint_ref
ENV octoprint_ref ${octoprint_ref}

RUN apk add --no-cache --upgrade --virtual .build-deps \
    gcc \
    libc-dev \
    musl-dev \
    libffi-dev \
    make 

RUN adduser -D octoprint
USER octoprint
WORKDIR /home/octoprint
ENV PATH /home/octoprint/.local/bin:$PATH

RUN python3 -m venv venv && \
    source venv/bin/activate && \
    pip install --user --no-cache-dir octoprint==${octoprint_ref}

USER root
RUN apk del .build-deps

FROM python:3.8-alpine AS runtime

RUN adduser -D octoprint && \
    addgroup octoprint tty && \
    addgroup octoprint video && \
    addgroup octoprint dialout && \
    apk add tini --no-cache

RUN /bin/ash -c 'set -e && \
    ARCH=`uname -m` && \
    if [ "$ARCH" == "armv7l" || "aarch64" ]; then \
    echo "ARM architecture detected, adding RPi extra dependencies." && \
    apk add --no-cache --upgrade --virtual .rpidev-deps \
    raspberrypi-dev \
    libgpiod-dev \
    py3-libgpiod \
    linux-tools-gpio; else \
    echo "Not an ARM architecture, skipping." && \
    continue; \
    fi'

USER octoprint
WORKDIR /home/octoprint

COPY --chown=octoprint:octoprint --from=compiler /home/octoprint /home/octoprint
COPY --chown=octoprint:octoprint ./supervisord.conf /etc/supervisord.conf
ENV PATH /home/octoprint/.local/bin:$PATH
ENV LD_LIBRARY_PATH /opt/vc/lib

RUN pip install --user supervisor vcgencmd --upgrade --no-cache-dir

EXPOSE 5000

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
