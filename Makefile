builddir=.build
cachedir=.cache
platforms?="linux/arm/v7,linux/arm64,linux/amd64,linux/i386"

build:
	docker-compose -f alpine/docker-compose.yml build

up:
	docker-compose -f alpine/docker-compose.yml up

down:
	docker-compose -f alpine/docker-compose.yml down

buildx-alpine:
	mkdir -p ${cachedir} ${builddir}
	docker buildx build \
	--platform ${platforms} \
	--cache-from type=local,src=${cachedir} \
	--output type=local,dest=${builddir} \
	--build-arg octoprint_ref=${octoprint_ref} \
	--progress tty -t growlab/octoprint-alpine ./alpine

buildx-mjpg:
	mkdir -p ${cachedir} ${builddir}
	docker buildx build \
	--platform ${platforms} \
	--cache-from type=local,src=${cachedir} \
	--output type=local,dest=${builddir} \
	--build-arg octoprint_ref=${octoprint_ref} \
	--progress tty -t growlab/mjpg-streamer ./mjpg-streamer
