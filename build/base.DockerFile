FROM golang:1.17-alpine
RUN apk --no-cache add gcc g++ make ca-certificates curl git openssh

WORKDIR /go/src/services

COPY go.mod go.sum ./

RUN go mod download
RUN go mod verify