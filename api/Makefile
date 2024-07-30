run:
	./mill api.run

compile:
	./mill all.compile

assembly:
	./mill api.assembly

test:
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	ARG_COUNT=$$(echo $$ARGS | wc -w); \
	if [ $$ARG_COUNT -eq 0 ]; then \
		./mill api.test; \
	elif [ $$ARG_COUNT -eq 1 ]; then \
		./mill api.test.testOnly $$ARGS; \
	else \
		echo "Usage: make t [arg1]"; \
		exit 1; \
	fi

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
