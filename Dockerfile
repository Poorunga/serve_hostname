FROM golang:1.14-alpine3.11 AS builder
WORKDIR /code
COPY . .
RUN CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags '-w' ./serve_hostname.go

FROM scratch
MAINTAINER Tim Hockin <thockin@google.com>
COPY --from=builder /code/serve_hostname /serve_hostname
EXPOSE 9376
ENTRYPOINT ["/serve_hostname"]
