NAME    := scottstanfield/rlang
# patch, minor, major
RELEASE ?= patch
CURRENT_VER := 1.0.4


#CURRENT_VER := $(shell git ls-remote --tags 2> /dev/null | awk '{ print $$2}'| sort -nr | head -n1|sed 's/refs\/tags\///g')

ifndef CURRENT_VER
  CURRENT_VER := 1.0.0
endif

NEXT_VER := $(shell docker run --rm alpine/semver semver -c -i $(RELEASE) $(CURRENT_VER))

current-version:
	@echo "Current: " $(CURRENT_VER)

next-version:
	@echo "Next:    "  $(NEXT_VER)

versions: current-version next-version

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
	git checkout master
	git tag $(NEXT_VER)
	git push --tags
	docker push ${NAME}

purge:
	@echo "Removing stopped containers"
	-docker rm -v $$(docker ps -a -q -f status=exited)
	@echo "Deleting all untagged/dangling (<none>) images"
	-docker rmi $$(docker images -q -f dangling=true)


