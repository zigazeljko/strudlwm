# strudlwm
# See LICENSE file for copyright and license details.

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# Xinerama
XINERAMALIBS = -L${X11LIB} -lXinerama
XINERAMAFLAGS = -DXINERAMA

# includes and libs
INCS = -I. -I/usr/include -I${X11INC}
LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 ${XINERAMALIBS}

# flags
CPPFLAGS = ${XINERAMAFLAGS}
#CFLAGS = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
CFLAGS = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
#LDFLAGS = -g ${LIBS}
LDFLAGS = -s ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS}
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc

SRC = strudlwm.c
OBJ = ${SRC:.c=.o}

all: options strudlwm

options:
	@echo strudlwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h

strudlwm: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f strudlwm ${OBJ} strudlwm-dist.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p strudlwm-dist
	@cp -R LICENSE Makefile README config.h strudlwm.1 ${SRC} strudlwm-dist
	@tar -cf strudlwm-dist.tar strudlwm-dist
	@gzip strudlwm-dist.tar
	@rm -rf strudlwm-dist

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f strudlwm ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/strudlwm
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@cp strudlwm.1 ${DESTDIR}${MANPREFIX}/man1/strudlwm.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/strudlwm.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/strudlwm
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/strudlwm.1

.PHONY: all options clean dist install uninstall
