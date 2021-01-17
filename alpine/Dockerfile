FROM python:3.8-alpine AS compiler

ARG octoprint_ref
ENV octoprint_ref ${octoprint_ref}

RUN apk add --no-cache --upgrade --virtual .build-deps \
    gcc \
    libc-dev \
    musl-dev \
    libffi-dev \
    make 

RUN /bin/ash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" != "x86_64" || "x86"]; then \
    echo "ARM architecture detected, installing extra libraries." && \
    apk add --no-cache --upgrade --virtual .rpidev-deps \
    raspberrypi-dev \
    libgpiod-dev \
    py3-libgpiod \
    linux-tools-gpio; else \
    echo "Not an ARM architecture, continuing." && \
    continue; \
    fi'

RUN adduser -D octoprint
USER octoprint
WORKDIR /home/octoprint
ENV PATH /home/octoprint/.local/bin:$PATH

#RUN pip install --user --no-cache-dir pip \
#    setuptools \
#    wheel

# RUN /bin/ash -c 'set -ex && \
#     ARCH=`uname -m` && \
#     if [ "$ARCH" != "x86_64" ]; then \
#     echo "ARM architecture detected, installing extra libraries." && \
#     pip install --no-cache-dir --user --upgrade RPi.GPIO; else \
#     echo "Not an ARM architecture, continuing." && \
#     continue; \
#     fi'

RUN python3 -m venv venv
RUN source venv/bin/activate
RUN pip install --user --no-cache-dir octoprint==${octoprint_ref}

USER root
RUN apk del .build-deps
RUN /bin/ash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" != "x86_64" ]; then \
    echo "ARM architecture detected, deleting unused dev dependencies." && \
    apk del .rpidev-deps; else \
    echo "Not an ARM architecture, skipping." && \
    continue; \
    fi'

FROM python:3.8-alpine AS runtime

RUN adduser -D octoprint && \
    addgroup octoprint tty && \
    addgroup octoprint video && \
    addgroup octoprint dialout && \
    apk add tini

RUN /bin/ash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" == "armv7l" ]; then \
    echo "ARM architecture detected, deleting unused dev dependencies." && \
    apk add --no-cache raspberrypi ; else \
    echo "Not an ARM architecture, skipping." && \
    continue; \
    fi'

USER octoprint
WORKDIR /home/octoprint

COPY --chown=octoprint:octoprint --from=compiler /home/octoprint /home/octoprint
COPY --chown=octoprint:octoprint ./supervisord.conf /etc/supervisord.conf
ENV PATH /home/octoprint/.local/bin:$PATH

RUN pip install --user supervisor --upgrade --no-cache-dir

EXPOSE 5000

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
