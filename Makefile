.PHONY: build run defult

#absolute path to your web root
#DIR_PATH = /

#docker tag name
IMAGE_NAME = httpd

PORT = 80

defult: run

build:
	docker build --tag=$(IMAGE_NAME) .

run: build
ifdef DIR_PATH
		docker run -p $(PORT) -v $(DIR_PATH):/var/www/ $(IMAGE_NAME)
endif
