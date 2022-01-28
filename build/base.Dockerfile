FROM golang:1.17-alpine
# FROM asia.gcr.io/core-v3-283604/99-workshop:base-1.0.0
RUN apk --no-cache add gcc g++ make ca-certificates curl git openssh

WORKDIR /go/src/services

COPY go.mod go.sum ./

# COPY config/.ssh/id_rsa /root/.ssh/id_rsa

#Getting credentials for private repository, you can disable if you don't need it
# RUN go env -w GOPRIVATE=github.com/urbanindo/* && \
#     mkdir -p /root/.ssh && \
#     chmod 600 /root/.ssh/id_rsa && \
#     printf "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile ~/.ssh/id_rsa" > /root/.ssh/config && \
#     printf "[url \"git@github.com:urbanindo/rumah123-auth.git\"]\n\tinsteadOf = https://github.com/urbanindo/rumah123-auth" > /root/.gitconfig

RUN go mod download
RUN go mod verify