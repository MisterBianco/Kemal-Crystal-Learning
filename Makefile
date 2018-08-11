test:
	KEMAL_ENV=test crystal spec

style-test:
	./tests/analyze-style

syntax-test:
	./tests/analyze-syntax

all-test:
	./tests/analyze-all

run:
	crystal run src/serv.cr

srun:
	sudo crystal run src/serv.cr

release:
	sudo crystal run src/serv.cr --release --no-debug

first-run:
	sudo crystal run src/serv.cr -- --migrate
