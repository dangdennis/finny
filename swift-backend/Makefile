d:
	watchexec --restart --exts swift -- make b

r:
	swift run

b:
	swift build

f: 
	swift-format format ./Sources --in-place --recursive --parallel

l:
	swift-format lint ./Sources --recursive --parallel 

migrate:
	swift run App migrate

revert:
	swift run App migrate --revert