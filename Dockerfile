FROM golang:1.12-alpine AS builder
ARG basedir=/go/build
WORKDIR ${basedir}
# Install some dependencies needed to build the project
RUN apk add ca-certificates git 
# Force the go compiler to use modules
ENV GOPROXY https://goproxy.io
ENV GO111MODULE=on
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy src and build
ADD . ${basedir}
RUN go build -o app

FROM alpine:3.8
# for https
RUN apk add --no-cache ca-certificates vim
# Finally we copy the statically compiled Go binary.
COPY --from=builder /go/build/app /app
ENTRYPOINT ["/app"]
