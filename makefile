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

build-clib2: checkout
	cd openssl/repo && ./Configure --openssldir=DEVS:AmiSSL no-hw no-dso amigaos-ppc-clib2
	# Fix up the paths
	sed <openssl/repo/Makefile -e "s/DEVS:AmiSSL\/DEVS:AmiSSL/DEVS:AmiSSL/" >/tmp/$@.ssl && mv /tmp/$@.ssl openssl/repo/Makefile
	sed <openssl/repo/crypto/opensslconf.h -e "s/DEVS:AmiSSL\/DEVS:AmiSSL/DEVS:AmiSSL/" >/tmp/$@.ssl && mv /tmp/$@.ssl openssl/repo/crypto/opensslconf.h
	sed <openssl/repo/tools/c_rehash -e "s/DEVS:AmiSSL\/DEVS:AmiSSL/DEVS:AmiSSL/" >/tmp/$@.ssl && mv /tmp/$@.ssl openssl/repo/tools/c_rehash
	cd openssl/repo && make build_libs
