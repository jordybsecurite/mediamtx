FROM golang:1.20-alpine3.18
RUN apk add --no-cache zip make git tar
WORKDIR /s
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
ARG VERSION
ENV CGO_ENABLED 0
RUN rm -rf tmp
RUN mkdir tmp
RUN cp mediamtx.yml LICENSE tmp/
RUN go mod tidy
RUN GOOS=linux GOARCH=amd64 go build -ldflags "-X github.com/bluenviron/mediamtx/internal/core.version=v1.0.2-fork" -o tmp/mediamtx
RUN mv tmp/mediamtx /mediamtx
ENTRYPOINT [ "/mediamtx" ]