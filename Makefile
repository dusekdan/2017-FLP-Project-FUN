#
# rv-2-rka Makefile
# 
#

all:
	ghc Main.hs -o rv-2-rka

clean:
	rm rv-2-rka.hi
	rm rv-2-rka.o
