# rv-2-rka
# xdusek21
# Daniel Dušek

all:
	ghc Main.hs -o rv-2-rka

clean:
	rm Main.hi
	rm Main.o
	rm FSMDrawer.o
	rm FSMDrawer.hi
	rm Types.o
	rm Types.hi


run-tests:
	echo "This is where I run tests"

drawFSM-1:
	./rv-2-rka -d "TestData/test.input.3.in"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated.tex" 1,2>/dev/null
	rm FSMImages/Generated.log FSMImages/Generated.aux

drawFSM-2:
	./rv-2-rka -d "TestData/test.input.2.in"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated.tex" 1,2>/dev/null
	rm FSMImages/Generated.log FSMImages/Generated.aux

drawFSM-3:
	./rv-2-rka -d "TestData/test.input.in"
	pdflatex -output-directory "FSMImages"  "FSMImages/Generated.tex" 1,2>/dev/null
	rm FSMImages/Generated.log FSMImages/Generated.aux



wis-pack:
	zip "flp-fun-xdusek21.zip" "Main.hs" "Makefile" "Types.hs" "FSMDrawer.hs" "README.md" "FSMImages" "TestData/test.input.in" "TestData/test.input.2.in" "TestData/test.input.3.in"
