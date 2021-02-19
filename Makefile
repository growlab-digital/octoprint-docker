builddir=.build
cachedir=.cache
platforms?="linux/arm/v7,linux/arm64,linux/amd64,linux/i386"

build:
		docker-compose build

up:
		docker-compose up -d

down:
		docker-compose down

stack-up:
		docker stack deploy -c traefik-stack.yml traefik && docker-compose up -d && docker stack deploy -c octofarm/octofarm-stack.yml farm

stack-down:
		docker-compose down && docker stack rm farm && docker stack rm traefik

traefik-compose-up:
		docker-compose -f traefik/docker-compose.yml up -d

traefik-compose-down:
		docker-compose -f traefik/docker-compose.yml down

traefik-swarm-up:
		docker stack deploy -c legacy-traefik-stack.yml traefik

traefik-swarm-down:
		docker stack rm traefik

farm-up:
		docker stack deploy -c octofarm/octofarm-stack.yml farm

farm-down:
		docker stack rm farm

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
