NAME    := scottstanfield/rlang
# patch, minor, major
RELEASE ?= patch
VERSION := 1.8.0

#VERSION := $(shell git ls-remote --tags 2> /dev/null | awk '{ print $$2}'| sort -nr | head -n1|sed 's/refs\/tags\///g')

version:
	@echo "Current: " $(VERSION)

LATEST	:= ${NAME}:latest
.DEFAULT_GOAL := build

build:
	$(eval IMG := ${NAME}:${VERSION})
	@echo "Building ${IMG}"
	@docker build  -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

run:
	@docker run --rm -it ${LATEST} zsh

release:
	git checkout master
	git tag $(VERSION)
	git push --tags
	docker push ${NAME}

purge:
	@echo "Removing stopped containers"
	-docker rm -v $$(docker ps -a -q -f status=exited)
	@echo "Deleting all untagged/dangling (<none>) images"
	-docker rmi $$(docker images -q -f dangling=true)
