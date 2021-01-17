builddir=.build
cachedir=.cache
octoprint_ref?= $(shell ./scripts/version.sh "OctoPrint/OctoPrint")
platforms?="linux/arm/v7,linux/arm64/v8,linux/amd64"

# .PHONY: test

# build:
# 	docker-compose -f test/docker-compose.yml build

# down:
# 	docker-compose -f test/docker-compose.yml down

# up:
# 	docker-compose -f test/docker-compose.yml up

# clean:
# 	docker-compose -f test/docker-compose.yml down --rmi local -v
# 	rm -rf ${builddir}

setup-multi-arch:
	docker run --privileged --rm tonistiigi/binfmt --install arm64,arm/v7,amd64

# test:
# 	./scripts/buildx_check.sh
# 	@echo '[buildx]: building .Dockerfile for all supported architectures and caching locally'
# 	mkdir -p ${cachedir} ${builddir}
# 	docker buildx build \
# 		--platform ${platforms} \
# 		--cache-from type=registry,ref=docker.io/octoprint/octoprint:${octoprint_ref} \
# 		--cache-from type=local,src=${cachedir} \
# 		--cache-to type=local,dest=${cachedir} \
# 		--build-arg octoprint_ref=${octoprint_ref} \
# 		--output type=local,dest=${builddir} \
# 		--progress tty -t octoprint/octoprint:test .

# e2e:
# 	@echo '[buildx]: building with test structures and running e2e tests'
# 	docker build \
# 		--secret id=password,src=./test/password.txt \
# 		--file ./test/Dockerfile \
# 		--progress tty -t octoprint/octoprint:e2e ./test
# 	docker-compose -f test/e2e-compose.yml up	

# build-minimal:
# 	docker build -t octoprint/octoprint:minimal -f minimal/Dockerfile --build-arg octoprint_ref=${octorprint_ref} ./minimal

# test-minimal:
# 	docker run -it --name octoprint_minimal -p 55000:5000 octoprint/octoprint:minimal

# clean-minimal:	
# 	docker rm octoprint_minimal

.PHONY: alpine

build:
	docker-compose -f alpine/docker-compose.yml build

up:
	docker-compose -f alpine/docker-compose.yml up

down:
	docker-compose -f alpine/docker-compose.yml down

buildx-alpine:
	# ./scripts/buildx_check.sh
	@echo '[buildx]: building octoprint-alpine/Dockerfile for all supported architectures and caching locally'
	mkdir -p ${cachedir} ${builddir}
	docker buildx build \
	--platform ${platforms} \
	--cache-from type=local,src=${cachedir} \
	--output type=local,dest=${builddir} \
	--build-arg octoprint_ref=${octoprint_ref} \
	--progress tty -t growlab/octoprint-alpine ./alpine

test-alpine:
	docker run -it --name octoprint_alpine -p 55000:5000 octoprint/octoprint:alpine

clean-alpine:	
	docker rm octoprint_alpine

push-build-alpine:
	docker push 