run:
	./mill app.run

compile:
	./mill app.test.compile app.compile

assembly:
	./mill app.assembly

test:
	./mill app.test

fix:
	./mill app.fix

r:
	./mill -w app.runBackground

c:
	./mill -w app.test.compile app.compile

t:
	./mill -w app.test

db-migrate:
	bunx prisma migrate deploy
