NAME    := scottstanfield/rlang
# patch, minor, major
RELEASE ?= patch


CURRENT_VER := $(shell git ls-remote --tags | awk '{ print $$2}'| sort -nr | head -n1|sed 's/refs\/tags\///g')

ifndef CURRENT_VER
  CURRENT_VER := 1.0.0
endif

NEXT_VER := $(shell docker run --rm alpine/semver semver -c -i $(RELEASE_TYPE) $(CURRENT_VER))

current-version:
	@echo $(CURRENT_VER)

next-version:
	@echo $(NEXT_VER)

LATEST	:= ${NAME}:latest


.DEFAULT_GOAL := build


build:
	$(eval IMG := ${NAME}:${CURRENT_VER})
	@echo "Building ${IMG}"
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

next:
	$(eval IMG := ${NAME}:${NEXT_VER})
	@echo "Building next version ${IMG}"
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

release:
	git checkout master;
	git tag $(NEXT_VER)
	git push --tags

push:
	@docker push ${NAME}

purge:
	@echo "Removing stopped containers"
	-docker rm -v $$(docker ps -a -q -f status=exited)
	@echo "Deleting all untagged/dangling (<none>) images"
	-docker rmi $$(docker images -q -f dangling=true)

