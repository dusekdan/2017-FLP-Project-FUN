#
# rv-2-rka Makefile
# 
#

all:
	ghc Main.hs -o rv-2-rka

clean:
	rm rv-2-rka.hi
	rm rv-2-rka.o

drawFSN-1:
	./rv-2-rka -d "TestData/test.input.in"
	pdflatex -output-directory "FSMImages"  "FSMImages/Generated.tex"
	rm FSMImages/Generated.log FSMImages/Generated.aux

drawFSN-2:
	./rv-2-rka -d "TestData/test.input.2.in"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated.tex"
	rm FSMImages/Generated.log FSMImages/Generated.aux

drawFSN-3:
	./rv-2-rka -d "TestData/test.input.3.in"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated.tex"
	rm FSMImages/Generated.log FSMImages/Generated.aux