run:
	./mill api.run

compile:
	./mill all.compile

assembly:
	./mill api.assembly

deploy:
	fly deploy

test:
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	ARG_COUNT=$$(echo $$ARGS | wc -w); \
	if [ $$ARG_COUNT -eq 0 ]; then \
		./mill test.test; \
	elif [ $$ARG_COUNT -eq 1 ]; then \
		./mill test.testOnly $$ARGS; \
	else \
		echo "Usage: make t [arg1]"; \
		exit 1; \
	fi

fix:
	make clean && ./mill api.fix && ./mill test.fix && ./mill cli.fix

fmt:
	scala fmt src/

clean:
	./mill clean

r:
	./mill -w api.runBackground

c:
	./mill -w all.compile

t:
	./mill -w test

restore-prod-db:
	sh ./src/test/services/restore_prod_db.sh
