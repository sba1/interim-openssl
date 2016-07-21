all: bin

.PHONY: bin
bin:
	mkdir -p bin
	cd bin && cd gild.git || (git clone https://github.com/sba1/gild.git gild.git && cd gild.git)
	cd bin/gild.git && git pull origin
	cp bin/gild.git/bin/* bin

.PHONY: checkout
checkout: bin
	./bin/gild clone
	./bin/gild checkout openssl 1.0.1

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

build-clib2-no-read-pw: checkout
	cd openssl/repo && ./Configure --openssldir=DEVS:AmiSSL no-hw no-dso amigaos-ppc-clib2-no-read-pw
	# Fix up the paths
	sed <openssl/repo/Makefile -e "s/DEVS:AmiSSL\/DEVS:AmiSSL/DEVS:AmiSSL/" >/tmp/$@.ssl && mv /tmp/$@.ssl openssl/repo/Makefile
	sed <openssl/repo/crypto/opensslconf.h -e "s/DEVS:AmiSSL\/DEVS:AmiSSL/DEVS:AmiSSL/" >/tmp/$@.ssl && mv /tmp/$@.ssl openssl/repo/crypto/opensslconf.h
	sed <openssl/repo/tools/c_rehash -e "s/DEVS:AmiSSL\/DEVS:AmiSSL/DEVS:AmiSSL/" >/tmp/$@.ssl && mv /tmp/$@.ssl openssl/repo/tools/c_rehash
	cd openssl/repo && make build_libs
