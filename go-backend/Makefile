run:
	go run main.go

build:
	go build -o bin/main main.go

build-release:
	go build -o bin/main -ldflags "-s -w" main.go

format:
	go fmt ./...

g:
	watchexec --restart --exts edgeql -- go generate ./...

r:
	watchexec --restart --exts go -- go run main.go

b:
	watchexec --restart --exts go -- go build -o bin/main main.go

f:
	watchexec --restart --exts go -- go fmt ./...

# migrate:
	# swift run App migrate

# revert:
	# swift run App migrate --revert
