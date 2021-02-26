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

export IMAGE_NAME:=gitlab
export IMAGE:=$(MAINTAINER)/$(IMAGE_NAME)
export CE_TAG:=$(CE_VERSION)

all: version build push
compile: version build

help:
	# General commands:
	# make all => build push
	# make version - show information about the current version
	#
	# Commands
	# make build - build the GitLab image
	# make push - push the image to Docker Hub

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

FORCE:
