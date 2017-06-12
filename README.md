# FLP FUN RV-2-RKA 
**Author**: [xdusek21](mailto:xdusek21@stud.fit.vutbr.cz)| Daniel Dušek 

Project for class of Functional and Logic Programming Languages, Faculty of Information Technology, Brno University of Technology, 2017.

#### **Content**
* Usage
* Dependencies and compilation 
* (Postfix) Regular expression to extended finite automaton algorithm 
* Extension for automaton drawing 
* ~Tests~


Application rv-2-rka accepts on its input regular expression written in reverse polish notation and converts it to extended finite automaton.

## Usage
`rv-2-rka ((-r|--represent) | (-t|--transform)) [FILE]`

`-r | --represent` reads from input file RE, converts it to internal representation and unchanged prints it back on standard output

`-t | --transform` reads from input file RE, converts it to EFA and prints the result on standard output

If no input file `[FILE]` is specified, standard input is read.
___
## Dependencies and compilation 
For parameters and argument processing, **[optparse-applicative](https://github.com/pcapriotti/optparse-applicative)** is used. To install the `optparse-applicative`, use `cabal update && cabal install optparse-applicative`.

If you are using linux distribution with GHC and GMake installed, it is possible to compile whole project using simple `make` command.

If you are using Microsoft Windows, you have to compile project by `ghc Main.hs` command.

Usage is same for both mentioned cases.

## (Postfix) Regular Expression to Extended Finite Automaton Algorithm

Desribed in [opory k předmětu TIN](http://www.fit.vutbr.cz/study/courses/TIN/public/Texty/oporaTIN.pdf) (in Czech). Implementation does not reduce resulting FA and leaves epsilon transitions. 

## Extension for automaton drawing

In my attempts to obtain bonus points for my project, I decided to implement extension that would allow to visualize resulting automaton. In order to do so, I implemented new switch `-d | --transform-draw`, which is used with the same syntax as switches `-t|-r`. 

`-d` switch outputs LaTeX code which after translation in environment with `tikz` module available generates PDF containing resulting automaton.


By calling:
 `./rv-2-rka -d TestData/test.input.1.in > TestLatex.tex | pdflatex TestLatex.tex` 
  we can get file TestLatex.pdf in which there is visualized resulting automaton.

 I wanted to avoid solution where I would have to run `pdflatex` from within haskell file itself which makes it harder to obtain the final image. That is solved in included `Makefile`, where there are several test-targets which will generate images to folder `FSMImages`:


```
make drawFSM-1  				# Vytvoří obrázek pro 'a'
make drawFSM-2					# Vytvoří obrázek pro 'ab.'
make drawFSM-3					# Vytvoří obrázek pro RV ze zadání

make drawEverything				# Vše výše zmíněné naráz
```

