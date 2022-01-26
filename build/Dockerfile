FROM asia.gcr.io/core-v3-283604/99-workshop:base-1.0.0 AS base

COPY . /app

RUN go build -v -o output/app ./cmd/app/
CMD ["./output/app"]