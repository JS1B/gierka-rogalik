FROM golang:latest as builder

WORKDIR /app

COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o rogalik-backend .

FROM alpine:latest
WORKDIR /app

COPY --from=builder /app/rogalik-backend .

COPY .env .
CMD [ "./rogalik-backend" ]