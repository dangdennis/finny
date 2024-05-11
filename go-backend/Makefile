run:
	go run .

build:
	go build -o bin/main main.go

build-release:
	go build -o bin/main -ldflags "-s -w" main.go

format:
	go fmt ./...

r:
	watchexec --restart --exts go -- make run

b:
	watchexec --restart --exts go -- make build

f:
	watchexec --restart --exts go -- make format

ps-gen:
	go run github.com/steebchen/prisma-client-go generate

ps-push:
	go run github.com/steebchen/prisma-client-go db push

ps-pull:
	go run github.com/steebchen/prisma-client-go db pull

ps-dev:
	go run github.com/steebchen/prisma-client-go migrate dev

ps-deploy:
	go run github.com/steebchen/prisma-client-go migrate deploy
