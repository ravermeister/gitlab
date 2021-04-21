export MAINTAINER:=ravermeister

all: build push

help:
	# General commands:
	# make all => build push
	# make prepare - prepare environment variables for given TARGET (arm32/arm64)
	# make info - show information about the current version
	# make version - return the platform and version machine friendly
	#
	# Commands
	# make build - build the GitLab image
	# make push - push the image to Docker Hub
	# make push-manifest - push manifest files to Docker hub using TAGLIST variable for choosing the docker images by tag
	# make taglist - returns the taglist

prepare: FORCE
ifeq ($(TARGET), arm64)
        export ARCHS:="ARM64v8 or later"
        export CE_VERSION:=$(shell ./ci/version arm64)
        export INIT_IMAGE:=true
else ifeq ($(TARGET), arm32)
        export ARCHS:="ARM32v7 or later"
        export CE_VERSION:=$(shell ./ci/version arm32)
        export INIT_IMAGE:=true
else
	$(error unknown Target >$(TARGET)<)
endif

export CE_TAG:=$(CE_VERSION)
export IMAGE_NAME:=gitlab
export IMAGE:=$(MAINTAINER)/$(IMAGE_NAME)

info: prepare
	@echo "---"
	@echo Version: $(CE_VERSION)
	@echo Image: $(IMAGE):$(TARGET)
	@echo Platorms: $(ARCHS)
	@echo ""
	@echo Brought to you by ravermeister
	@echo "---"

build: info
	# Build the GitLab image
	@./ci/build

push:
	# Push image to Registries
	@./ci/release

push-manifest:
	# create manifest and push to Registries
	@./ci/release-manifest

version:
	@echo $(TARGET)-$(CE_VERSION)

FORCE:
