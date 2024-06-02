run:
	go run . -p 8000

build:
	go build -o bin/main main.go

build-release:
	go build -o bin/main -ldflags "-s -w" main.go

format:
	go fmt ./...

r:
	watchexec --exts go -- make run

b:
	watchexec --exts go -- make build

f:
	watchexec --exts go -- make format
