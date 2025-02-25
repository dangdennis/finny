# Finny Backend

Backend service for Finny, written in Go.

## Prerequisites

- Go 1.23 or higher
- [Air](https://github.com/air-verse/air) for live reloading during development
- [Fly.io](https://fly.io) account for deployment

## Getting Started

### Installation

1. Install Air for live reloading:
```bash
go install github.com/air-verse/air@latest
```

2. Install the Go linter:
```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

2. Install dependencies:
```bash
go mod tidy
```

## Development

### Running locally

Use Air for live reloading during development:
```bash
make dev
```

Or run the http server directly with Go:
```bash
go run main.go serve
```

We also need to run ngrok if you are planning to develop the oauth workflow.

Install [ngrok](https://ngrok.com/docs/getting-started/).
```
ngrok http 8080
```

### Available Make commands

- `make dev` - Run the server with live reloading using Air
- `make build` - Build the application
- `make serve` - Run the application
- `make test` - Run tests
- `make fmt` - Format code
- `make vet` - Run Go vet for static analysis
- `make lint` - Run the linter

## Deployment

This project is deployed using Fly.io.

1. Install the Fly CLI if you haven't already:
```bash
# On macOS
brew install flyctl

# Other platforms: https://fly.io/docs/hands-on/install-flyctl/
```

2. Deploy to Fly:
```bash
fly deploy
```

## Project Structure

```
finny-backend/
├── bin # From main.go, calls out to these applications as part of the CLI.
├── internal # Internal packages
└── main.go # Entrypoint for our application
```
