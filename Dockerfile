FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
        ca-certificates libidn11 libssl1.0.0 openssl wget \
        git \
        libssl-dev libreadline-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.9.4
RUN set -eux; \
    url="https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"; \
    wget -O go.tgz "$url"; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    export PATH="/usr/local/go/bin:$PATH"; \
    go version

ENV GOPATH /go

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN eval "$(~/.rbenv/bin/rbenv init -)"
RUN mkdir -p ~/.rbenv/plugins
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/bin/rbenv install 2.4.1
RUN ~/.rbenv/versions/2.4.1/bin/gem install bundler

RUN mkdir -p $GOPATH/src/github.com/Originate/git-town

ENV PATH $HOME/.rbenv/bin:$GOPATH/bin:/usr/local/go/bin:$PATH
WORKDIR $GOPATH/src/github.com/Originate/git-town
