export MAINTAINER:=ravermeister
export CE_VERSION:="$(shell ./ci/version)"
export CE_TAG:=$(CE_VERSION)

ifeq ($(TARGET), "arm64")
	export IMAGE_NAME:="arm64-gitlab"
	export IMAGE:="$(MAINTAINER)/$(IMAGE_NAME)"
	export ARCHS:="ARM64v8 or later"
	export DOCKERFILE:="docker/Dockerfile.arm64"
else
	export IMAGE_NAME:="armhf-gitlab"
	export IMAGE:="$(MAINTAINER)/$(IMAGE_NAME)"
	export ARCHS:="ARM32v7 or later"
	export DOCKERFILE:="docker/Dockerfile.armhf"
endif

# ifeq ($(CI_COMMIT_REF_NAME), "master")
# 	export CE_TAG=$(CE_VERSION)
# endif

all: version build push

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
