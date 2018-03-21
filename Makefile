#!/usr/bin/env make -f

PREFIX=/usr
IDENTIFIER=org.zysuper.riceCracker

VERSION=1.0

CC=llvm-g++
PACKAGE_BUILD=/usr/bin/pkgbuild
ARCH_FLAGS=-arch x86_64

.PHONY: build

dist: riceCrackerDaemon org.zysuper.riceCracker.daemon.plist
	mkdir dist
	cp riceCrackerDaemon dist/
	cp org.zysuper.riceCracker.daemon.plist dist/
	cp readme.md dist/
	cp install*.command dist/

riceCrackerDaemon: main.o utils.o wakeupRegister.o
	$(CC) $^ -o $@ $(ARCH_FLAGS) -framework Foundation -framework ApplicationServices -framework AppKit -framework IoKit 


clean:
	rm -f *.o
	rm -rf dist

%.o: %.mm
	$(CC) $(CPPFLAGS) $(CFLAGS) $(ARCH_FLAGS) $< -c -o $@


.PHONY: install build clean
