# Build stage
ARG GO_VERSION=1.22
FROM golang:${GO_VERSION}-bookworm as builder

WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o /run-app .

# Final stage
FROM debian:bookworm

# Install CA certificates
RUN apt-get update && apt-get install -y ca-certificates

# Copy the built application from the builder stage
COPY --from=builder /run-app /usr/local/bin/

# Set the entrypoint for the container
CMD ["run-app"]
