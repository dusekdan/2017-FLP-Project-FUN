# rv-2-rka
# xdusek21
# Daniel Dušek

SHELL = bash

all:
	ghc Main.hs -o rv-2-rka

clean:
	rm Main.hi
	rm Main.o
	rm FSMDrawer.o
	rm FSMDrawer.hi
	rm Types.o
	rm Types.hi


drawFSM-1:
	./rv-2-rka -d "TestData/test.input.1.in" > "FSMImages/Generated-1.tex"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated-1.tex" 1,2>/dev/null
	rm FSMImages/Generated-1.log FSMImages/Generated-1.aux

drawFSM-2:
	./rv-2-rka -d "TestData/test.input.2.in" > "FSMImages/Generated-2.tex"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated-2.tex" 1,2>/dev/null
	rm FSMImages/Generated-2.log FSMImages/Generated-2.aux

drawFSM-3:
	./rv-2-rka -d "TestData/test.input.3.in" > "FSMImages/Generated-3.tex"
	pdflatex -output-directory "FSMImages" "FSMImages/Generated-3.tex" 1,2>/dev/null
	rm FSMImages/Generated-3.log FSMImages/Generated-3.aux

drawEverything: drawFSM-1 drawFSM-2 drawFSM-3

run-tests: all test-transform-1 test-transform-2 test-transform-3 test-represent-1 test-represent-2 test-represent-3
test-transform-1:
	@if diff <(./rv-2-rka -t "TestData/test.input.1.in") "TestData/test.input.1.out"  &> /dev/null; then echo -e "Transform test 01: \e[32mOK\e[39m"; else echo -e "Transform test 01: \e[31mK.O.\e[39m"; fi
test-transform-2:
	@if diff <(./rv-2-rka -t "TestData/test.input.2.in") "TestData/test.input.2.out"  &> /dev/null; then echo -e "Transform test 02: \e[32mOK\e[39m"; else echo -e "Transform test 02: \e[31mK.O.\e[39m"; fi
test-transform-3:
	@if diff <(./rv-2-rka -t "TestData/test.input.3.in") "TestData/test.input.3.out" &> /dev/null; then echo -e "Transform test 03: \e[32mOK\e[39m"; else echo -e "Transform test 03: \e[31mK.O.\e[39m"; fi
test-represent-1:
	@if diff <(./rv-2-rka -r "TestData/test.input.1.in") "TestData/test.input.1.in" &> /dev/null; then echo -e "Represent test 01: \e[32mOK\e[39m"; else echo -e "Represent test 01: \e[31mK.O.\e[39m"; fi
test-represent-2:
	@if diff <(./rv-2-rka -r "TestData/test.input.2.in") "TestData/test.input.2.in" &> /dev/null; then echo -e "Represent test 02: \e[32mOK\e[39m"; else echo -e "Represent test 02: \e[31mK.O.\e[39m"; fi
test-represent-3:
	@if diff <(./rv-2-rka -r "TestData/test.input.3.in") "TestData/test.input.3.in" &> /dev/null; then echo -e "Represent test 03: \e[32mOK\e[39m"; else echo -e "Represent test 03: \e[31mK.O.\e[39m"; fi



wis-pack:
	zip "flp-fun-xdusek21.zip" "Main.hs" "Makefile" "Types.hs" "FSMDrawer.hs" "README.md" "FSMImages" TestData/*
