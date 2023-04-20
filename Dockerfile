FROM golang:1.18-stretch as builder

ADD . /go/src/exporter

WORKDIR /go/src/exporter

# 禁用 CGO，避免 so 问题
ENV CGO_ENABLED=0
RUN go build -v -o /go/src/bin/exporter main.go

FROM alpine:3
LABEL maintainers="Jakes Lee"
LABEL description="iKuai exporter"

EXPOSE 9090

COPY --from=builder /go/src/bin/exporter /exporter

WORKDIR /data

RUN chmod +x /exporter
CMD ["/exporter"]
