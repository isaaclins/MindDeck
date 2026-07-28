SHELL := /bin/sh

FLUTTER ?= flutter
DART ?= dart
NPM ?= npm
DEVICE ?=

ifeq ($(OS),Windows_NT)
HOST_PLATFORM := windows
else
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
HOST_PLATFORM := macos
else
HOST_PLATFORM := linux
endif
endif

PLATFORM ?= $(HOST_PLATFORM)
DEVICE_ARG := $(if $(DEVICE),-d "$(DEVICE)",)

.DEFAULT_GOAL := help

.PHONY: help setup start build build-android build-ios build-macos build-linux build-windows site site-build format analyze test check clean

help:
	@echo "MindDeck commands"
	@echo ""
	@echo "  make setup                    Install app and website dependencies"
	@echo "  make start                    Run on the default Flutter device"
	@echo "  make start DEVICE=<device>    Run on a named device"
	@echo "  make build                    Build a release for this host"
	@echo "  make build PLATFORM=<target>  Build apk, ios, macos, windows, or linux"
	@echo "  make site                     Start the website locally"
	@echo "  make site-build               Build the production website"
	@echo "  make check                    Format-check, analyze, and run every test"
	@echo "  make clean                    Remove generated build output"

setup:
	$(FLUTTER) pub get --enforce-lockfile
	cd website && $(NPM) ci

start:
	$(FLUTTER) pub get --enforce-lockfile
	$(FLUTTER) run $(DEVICE_ARG)

build:
	$(FLUTTER) pub get --enforce-lockfile
	$(FLUTTER) build $(PLATFORM) --release

build-android:
	$(MAKE) build PLATFORM=apk

build-ios:
	$(FLUTTER) pub get --enforce-lockfile
	$(FLUTTER) build ios --release --no-codesign

build-macos:
	$(MAKE) build PLATFORM=macos

build-linux:
	$(MAKE) build PLATFORM=linux

build-windows:
	$(MAKE) build PLATFORM=windows

site:
	cd website && $(NPM) run dev

site-build:
	cd website && $(NPM) ci
	cd website && VITE_BASE_PATH=/MindDeck/ $(NPM) run build

format:
	$(DART) format lib test integration_test

analyze:
	$(FLUTTER) analyze --fatal-infos --fatal-warnings

test:
	$(FLUTTER) test
	cd website && $(NPM) test

check:
	$(DART) format --output=none --set-exit-if-changed lib test integration_test
	$(FLUTTER) analyze --fatal-infos --fatal-warnings
	$(FLUTTER) test
	cd website && $(NPM) test
	cd website && VITE_BASE_PATH=/MindDeck/ $(NPM) run build

clean:
	$(FLUTTER) clean
	rm -rf website/dist
