%:
	docker run -ti --rm -v $(shell pwd)/.go:/home/go/go -v $(shell pwd):/home/go/go/src/github.com/Originate/git-town git-town-dev-docker:latest bin/$@

all: setup build spec
