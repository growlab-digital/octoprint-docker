builddir=.build
cachedir=.cache
octoprint_ref?= $(shell ./scripts/version.sh "OctoPrint/OctoPrint")
platforms?="linux/arm/v7,linux/arm64,linux/amd64,linux/i386"

build:
	docker-compose -f alpine/docker-compose.yml build

up:
	docker-compose -f alpine/docker-compose.yml up

down:
	docker-compose -f alpine/docker-compose.yml down

buildx-alpine:
	./scripts/buildx_check.sh
	@echo '[buildx]: building octoprint-alpine/Dockerfile for all supported architectures and caching locally'
	mkdir -p ${cachedir} ${builddir}
	docker buildx build \
	--platform ${platforms} \
	--cache-from type=local,src=${cachedir} \
	--output type=local,dest=${builddir} \
	--build-arg octoprint_ref=${octoprint_ref} \
	--progress tty -t growlab/octoprint-alpine ./alpine
