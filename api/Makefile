run:
	./mill app.run

compile:
	./mill all.compile

assembly:
	./mill app.assembly

test:
	./mill app.test

fix:
	make clean && ./mill all.fix 
	
fmt:
	./mill app.reformat && ./mill app.test.reformat && ./mill cli.reformat

clean:
	./mill clean

r:
	./mill -w app.runBackground

c:
	./mill -w all.compile

t:
	./mill -w app.test