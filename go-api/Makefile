run:
	go run . -p 8000

build:
	go build -o bin/main .

build-release:
	go build -o bin/main -ldflags "-s -w" .

format:
	go fmt ./...

r:
	watchexec --exts go -- make run

b:
	watchexec --exts go -- make build

f:
	watchexec --exts go -- make format

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
