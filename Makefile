export MAINTAINER:=ravermeister

ifeq ($(TARGET), arm64)
	export ARCHS:="ARM64v8 or later"
	export DOCKERFILE:=docker/arm64.dockerfile
	export CE_VERSION:=$(shell ./ci/version arm64)

else
	export ARCHS:="ARM32v7 or later"
	export DOCKERFILE:=docker/armhf.dockerfile
	export CE_VERSION:=$(shell ./ci/version armhf)
endif

export CE_TAG:=$(CE_VERSION)
export IMAGE_NAME:=gitlab
export IMAGE:=$(MAINTAINER)/$(IMAGE_NAME)

all: version build push

help:
	# General commands:
	# make all => build push
	# make version - show information about the current version
	#
	# Commands
	# make build - build the GitLab image
	# make push - push the image to Docker Hub
	# make push-manifest - push manifest files to Docker hub using TAGLIST variable for choosing the docker images by tag
	# make taglist - returns the taglist

version: FORCE
	@echo "---"
	@echo Version: $(CE_VERSION)
	@echo Image: $(IMAGE):$(CE_TAG)
	@echo Platorms: $(ARCHS)
	@echo ""
	@echo Brought to you by ravermeister
	@echo "---"

build: version
	# Build the GitLab image
	@./ci/build
	
push:
	# Push image to Registries
	@./ci/release
	
push-manifest:
	# create manifest and push to Registries
	@./ci/release-manifest

tagversion:
	@echo $(TARGET)-$(CE_VERSION)


FORCE:
