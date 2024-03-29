#
# @(#)Makefile	1.17 11/01/03
#
# Makefile for "uncgi"
#

#
# Set this to your favorite C compiler.
#
CC=gcc -g

#
# Set this to the directory where your CGI scripts live.  Uncgi will look
# there for backend scripts.
#
SCRIPT_BIN=/var/uncgi

#
# Set this to the directory you'd like to install uncgi in, typically your
# server's cgi-bin directory (if any)
#
DESTDIR=/usr/lib/cgi-bin

#
# Set this to the filename extension, if any, that your server requires
# be at the end of CGI programs.  Typically this is either nothing at all
# (if your server always looks for scripts in a particular directory) or
# ".cgi".  Note that your backend scripts, the things Un-CGI runs, don't
# have to have any particular kind of filename.
#
#EXTENSION=.cgi

#
# If Un-CGI can't find your scripts, uncomment this and recompile and its
# error message will contain the full path of where it thinks your scripts
# should be.
#
#DEBUG=-DDEBUG

#
# Security-related options.
#
# -DEXECUTABLES_ONLY - Only execute scripts that have the execute flag
#		       set in their file permissions (chmod +x).  If
#		       this option isn't present, uncgi can run scripts
#		       that start with "#!" even if they aren't marked
#		       as executable in the filesystem.  Some sites find
#		       this capability convenient as it allows scripts
#		       to be maintained without command-line access
#		       using FTP.
#
SECURITY=-DEXECUTABLES_ONLY

#
# If you get a compile error about "strerror" not being defined, uncomment
# the following.
#
#STRERROR=-DUSE_SYS_ERRLIST

#
# If you don't want Un-CGI to spit out an error when there are no form
# variables present to pass down to the backend program, uncomment this.
#
NOQUERY=-DNO_QUERY_OK

#
# For HP-UX 10.0, uncomment the following.
#
#SYSDEP=-D_INCLUDE_POSIX_SOURCE

#############################################################################

MYCFLAGS=-DSCRIPT_BIN='"$(SCRIPT_BIN)"' $(DEBUG) $(SECURITY) $(NOQUERY) $(SYSDEP) $(STRERROR)

uncgi: uncgi.c
	$(CC) $(CFLAGS) $(MYCFLAGS) -o $@ uncgi.c

install: uncgi
	-rm -f $(DESTDIR)/uncgi$(EXTENSION)
	cp uncgi $(DESTDIR)/uncgi$(EXTENSION)
	chmod 755 $(DESTDIR)/uncgi$(EXTENSION)

shar:
	shar README Makefile uncgi.c > uncgi.shar

tar:
	chmod +w Makefile
	cd ..; \
		tar cvf - uncgi/README uncgi/Makefile \
			uncgi/uncgi.c | compress > uncgi/uncgi.tar.Z; \
		cd uncgi
	chmod -w Makefile

zip:
	chmod +w Makefile
	cd ..; \
		zip uncgi/uncgi.zip uncgi/README.1ST uncgi/README \
			uncgi/Makefile uncgi/uncgi.c; \
		cd uncgi
	chmod -w Makefile
