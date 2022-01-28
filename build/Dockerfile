#FROM $gcr_url/$product_name:$base_name-$version_number AS compiler
# FROM asia.gcr.io/core-v3-283604/99-workshop:priyandiono-develop-123123-20220128  AS compiler
FROM asia.gcr.io/core-v3-283604/99-workshop:base-1.0.0 AS compiler


WORKDIR /go/src/services
COPY . /go/src/services

ARG CMD_PATH
ENV CMD_PATH=${CMD_PATH}

RUN go build -v -o /go/bin/app ./${CMD_PATH}/...

FROM alpine:3.14
WORKDIR /root/
COPY --from=compiler /go/bin/app .

CMD ["./app"]