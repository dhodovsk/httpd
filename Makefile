IMAGE_NAME = httpd

MODULEMDURL=file://httpd.yaml

default: run

build:
	docker build --tag=$(IMAGE_NAME) .

run: build
	docker run -it -p 8080:8080 -p 443:443 $(IMAGE_NAME)

debug: build
	docker run -it -p 8080:8080 -p 443:443 $(IMAGE_NAME) bash

test: build
	cd tests; MODULE=docker MODULEMD=$(MODULEMDURL) URL="docker=$(IMAGE_NAME)" make all
