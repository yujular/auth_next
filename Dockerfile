FROM golang:1.22-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./
RUN apk add --no-cache --virtual .build-deps \
        ca-certificates \
        tzdata \
        gcc \
        g++ &&  \
    go mod download

COPY . .

RUN go build -ldflags "-s -w" -o auth

FROM alpine

WORKDIR /app

COPY --from=builder /app/auth /app/
COPY data data

VOLUME ["/app/data"]

ENV MODE=production

EXPOSE 8000

ENTRYPOINT ["./auth"]