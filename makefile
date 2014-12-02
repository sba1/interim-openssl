all: bin

.PHONY: bin
bin:
	mkdir -p bin
	cd bin && cd adtools || (git clone https://github.com/sba1/adtools.git && cd adtools)
	cd bin/adtools && git pull origin
	cp bin/adtools/bin/* bin

.PHONY: checkout
checkout: bin
	./bin/adtclone
	./bin/adtcheckout openssl 1.0.1

.PHONY: build
build:
	cd openssl/repo && ./Configure --openssldir=DEVS:AmiSSL no-hw no-dso amigaos-ppc
	cd openssl/repo && make
