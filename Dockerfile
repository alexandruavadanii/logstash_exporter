FROM golang:1.9 as golang

ADD . $GOPATH/src/github.com/BonnierNews/logstash_exporter/
RUN go get -u github.com/golang/dep && \
        cd $GOPATH/src/github.com/golang/dep && \
        make build install && \
        go get -u github.com/BonnierNews/logstash_exporter && \
        cd $GOPATH/src/github.com/BonnierNews/logstash_exporter && \
        dep ensure && \
        make

FROM busybox:1.27.2-glibc
COPY --from=golang /go/src/github.com/BonnierNews/logstash_exporter/logstash_exporter /
LABEL maintainer christoffer.kylvag@bonniernews.se
EXPOSE 9198
ENTRYPOINT ["/logstash_exporter"]
