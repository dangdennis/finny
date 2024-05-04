run:
	swift run
	
build:
	swift build

build-release:
	swift build -c release

format:
	swift-format format ./Sources --in-place --recursive --parallel
	
r:
	watchexec --restart --exts swift -- make run

b:
	watchexec --restart --exts swift -- make build

f: 
	watchexec --restart --exts swift -- make format

l:
	swift-format lint ./Sources --recursive --parallel 

migrate:
	swift run App migrate

revert:
	swift run App migrate --revert