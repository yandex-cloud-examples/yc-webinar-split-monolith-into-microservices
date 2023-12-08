FROM golang:1.19 as build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
COPY .. ./

RUN GOOS=linux go build -o /server

EXPOSE 8080

CMD ["/server"]