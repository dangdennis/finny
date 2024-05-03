run:
	swift run
	
build:
	swift build

build-release:
	swift build -c release
	
r:
	watchexec --restart --exts swift -- make run

b:
	watchexec --restart --exts swift -- make build

f: 
	swift-format format ./Sources --in-place --recursive --parallel

l:
	swift-format lint ./Sources --recursive --parallel 

migrate:
	swift run App migrate

revert:
	swift run App migrate --revert