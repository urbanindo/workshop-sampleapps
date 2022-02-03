FROM asia.gcr.io/core-v3-283604/99-workshop:deni-base-1.0.0 AS compiler

WORKDIR /go/src/services
COPY . /go/src/services

ARG CMD_PATH
ENV CMD_PATH=${CMD_PATH}

RUN go build -v -o /go/bin/app ./${CMD_PATH}/...

FROM alpine:3.14
WORKDIR /root/
COPY --from=compiler /go/bin/app .

CMD ["./app"] 