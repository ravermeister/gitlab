export MAINTAINER:=ravermeister

ifeq ($(TARGET), arm64)
	export ARCHS:="ARM64v8 or later"
	export CE_VERSION:=$(shell ./ci/version arm64)
else ifeq
	export ARCHS:="ARM32v7 or later"
	export CE_VERSION:=$(shell ./ci/version arm32)
else
	$(error Unknown Target >$(TARGET)<)
	exit 1
endif

export CE_TAG:=$(CE_VERSION)
export IMAGE_NAME:=gitlab
export IMAGE:=$(MAINTAINER)/$(IMAGE_NAME)

all: info build push

help:
	# General commands:
	# make all => build push
	# make info - show information about the current version
	# make version - return the platform and version machine friendly
	#
	# Commands
	# make build - build the GitLab image
	# make push - push the image to Docker Hub
	# make push-manifest - push manifest files to Docker hub using TAGLIST variable for choosing the docker images by tag
	# make taglist - returns the taglist

info: FORCE
	@echo "---"
	@echo Version: $(CE_VERSION)
	@echo Image: $(IMAGE):$(CE_TAG)
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
