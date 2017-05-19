DOCKER_IMAGE_VERSION=3.2.9
DOCKER_IMAGE_NAME=knjcode/arm64-redis
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

default: build

build:
	docker pull aarch64/debian:jessie
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:
	docker push $(DOCKER_IMAGE_TAGNAME)
	docker push $(DOCKER_IMAGE_NAME):latest

test:
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."
	@ID=$$(docker run -d -p 0:6379 $(DOCKER_IMAGE_TAGNAME)) && \
	PORT=$$(docker port $$ID | cut -d: -f2) && \
	redis-cli -p $$PORT keys \* && \
	redis-cli -p $$PORT set foo bar && \
	redis-cli -p $$PORT get foo && \
	docker rm -f $$ID

version:
	docker run --rm --entrypoint redis-server $(DOCKER_IMAGE_TAGNAME) --version
