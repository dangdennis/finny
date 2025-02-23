dev:
	air serve

build:
	go build main.go

serve:
	go run main.go serve

test:
	go test ./...

fmt:
	go fmt ./...

vet:
	go vet ./...

lint:
	golangci-lint run

upgrade-deps:
	go get -u ./...

.PHONY: build serve test fmt vet
