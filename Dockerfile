FROM crystallang/crystal:1.0.0-alpine
COPY . /src
WORKDIR /src
RUN shards build --release --static

FROM golang:alpine
RUN go get -u github.com/vishen/go-chromecast

FROM alpine
RUN apk add tini
COPY --from=0 /src/bin/castblock /usr/bin/castblock
COPY --from=1 /go/bin/go-chromecast /usr/bin/go-chromecast
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/castblock"]
