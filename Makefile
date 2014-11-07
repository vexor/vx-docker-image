VERSION := $(shell cat version.txt)

build:
	cd docker/trusty
	docker build -t vexor/trusty:$(VERSION)
