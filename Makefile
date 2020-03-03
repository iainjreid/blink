BIN ?= blink

install:
	cp blink.sh $(HOME)/bin/$(BIN)

uninstall:
	rm -f $(HOME)/bin/$(BIN)
