FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
        ca-certificates openssl curl \
        apt-transport-https \
        git \
        libssl-dev libreadline-dev zlib1g-dev \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

ENV UID=1000
ENV GOLANG_VERSION 1.9.4

RUN useradd --no-log-init -ms /bin/bash -u $UID go
RUN set -eux; \
    url="https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"; \
    curl -L "$url" > go.tgz; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    export PATH="/usr/local/go/bin:$PATH"; \
    go version

ENV GOPATH /home/go/go

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chown -R go:go "$GOPATH"
USER go

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && export PATH="/home/go/.rbenv/shims:/home/go/.rbenv/bin:$PATH" \
    && mkdir -p ~/.rbenv/plugins \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    && rbenv install 2.4.1 \
    && rbenv global 2.4.1 \
    && gem install bundler

RUN mkdir -p $GOPATH/src/github.com/Originate/git-town
WORKDIR $GOPATH/src/github.com/Originate/git-town
ENV PATH $GOPATH/src/github.com/Originate/git-town/bin:/home/go/.rbenv/shims:/home/go/.rbenv/bin:$GOPATH/bin:/usr/local/go/bin:$PATH
