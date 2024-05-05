run:
	swift run
	
build:
	swift build

build-release:
	swift build -c release

fmt:
	swift-format format ./Sources --in-place --recursive --parallel

lint:
	swift-format lint ./Sources --recursive --parallel
	
r:
	watchexec --restart --exts swift -- make run

b:
	watchexec --restart --exts swift -- make build

f: 
	watchexec --restart --exts swift -- make fmt

l:
	watchexec --restart --exts swift -- make lint

migrate:
	swift run App migrate

revert:
	swift run App migrate --revert