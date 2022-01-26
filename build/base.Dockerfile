FROM golang:1.17-alpine
RUN apk --no-cache add gcc g++ make ca-certificates curl git openssh

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download
RUN go mod verify
