FROM golang:1.17-alpine
RUN apk --no-cache add gcc g++ make ca-certificates curl git openssh

WORKDIR /go/src/listing
COPY . /go/src/listing
ARG CMD_PATH
ENV CMD_PATH=${CMD_PATH}

# RUN go env -w GOPRIVATE=github.com/urbanindo/* && \
#     mkdir -p /root/.ssh && \
#     cp -v config/.ssh/id_rsa /root/.ssh/id_rsa && \
#     chmod 600 /root/.ssh/id_rsa && \
#     printf "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile ~/.ssh/id_rsa" > /root/.ssh/config && \
#     printf "[url \"git@github.com:urbanindo/rumah123-auth.git\"]\n\tinsteadOf = https://github.com/urbanindo/rumah123-auth" > /root/.gitconfig

# RUN go get github.com/githubnemo/CompileDaemon

RUN go mod download
RUN go mod verify

ENTRYPOINT CompileDaemon -exclude-dir=".git" -build="go build -v -o /go/bin/app /go/src/listing/${CMD_PATH}/..." -command="/go/bin/app" 