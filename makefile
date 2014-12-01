all: bin

.PHONY: bin
bin:
	mkdir -p bin
	cd bin && cd adtools || (git clone https://github.com/sba1/adtools.git && cd adtools)
	cd bin/adtools && git pull origin
	cp bin/adtools/bin/* bin
