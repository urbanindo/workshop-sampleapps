FROM golang:1.17-alpine
RUN apk --no-cache add gcc g++ make ca-certificates curl git openssh

WORKDIR /home/user/coder/workshop-sampleapps

COPY go.mod go.sum ./

# COPY config/.ssh/id_rsa /root/.ssh/id_rsa

# RUN go env -w GOPRIVATE=github.com/urbanindo/* && \
#     mkdir -p /root/.ssh && \
#     chmod 600 /root/.ssh/id_rsa && \
#     printf "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile ~/.ssh/id_rsa" > /root/.ssh/config && \
#     printf "[url \"git@github.com:urbanindo/rumah123-auth.git\"]\n\tinsteadOf = https://github.com/urbanindo/rumah123-auth" > /root/.gitconfig

RUN go mod download
RUN go mod verify