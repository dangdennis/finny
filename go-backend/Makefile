run:
	go run .

build:
	go build -o bin/main main.go

build-release:
	go build -o bin/main -ldflags "-s -w" main.go

generate:
	go generate ./...

format:
	go fmt ./...

g:
	watchexec --restart --exts edgeql -- make generate

r:
	watchexec --restart --exts go -- make run

b:
	watchexec --restart --exts go -- make build

f:
	watchexec --restart --exts go -- make format

# migrate:
	# swift run App migrate

# revert:
	# swift run App migrate --revert
