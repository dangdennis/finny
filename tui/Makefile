run:
	python main.py

install:
	uv pip install -r requirements.txt

fmt:
	ruff format .

check:
	ruff check . --fix

lock:
	uv pip freeze | uv pip compile - -o requirements.txt
