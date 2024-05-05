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

prismagen:
	go run github.com/steebchen/prisma-client-go generate

prismapush:
	go run github.com/steebchen/prisma-client-go db push

prismapull:
	go run github.com/steebchen/prisma-client-go db pull

prismadev:
	go run github.com/steebchen/prisma-client-go migrate dev

prismadeploy:
	go run github.com/steebchen/prisma-client-go migrate deploy
