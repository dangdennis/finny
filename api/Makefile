run:
	./mill api.run

compile:
	./mill all.compile

assembly:
	./mill api.assembly

test:
	./mill api.test

fix:
	make clean && ./mill api.fix && ./mill api.test.fix && ./mill cli.fix
	
fmt:
	./mill api.reformat && ./mill api.test.reformat && ./mill cli.reformat

clean:
	./mill clean

r:
	./mill -w api.runBackground

c:
	./mill -w all.compile

t:
	./mill -w api.test