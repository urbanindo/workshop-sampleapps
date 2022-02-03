FROM golang:1.17-alpine

WORKDIR /go/src/services

COPY go.mod go.sum ./

RUN go get -u
