# FLP FUN RV-2-RKA 
**Author**: [xdusek21](mailto:xdusek21@stud.fit.vutbr.cz)| Daniel Dušek 

####**Osnova**
* Použití
*  Závislosti a překlad *
* Algoritmus převodu RV na RKA 
*  Implementované rozšíření pro vykreslování RKA 
* Testy

Aplikace rv-2-rka přijme na svém vstupu regulární výraz zapsaný v postfixovém tvaru a transformuje ho na rozšířený konečný automat. 

## Použití
`rv-2-rka ((-r|--represent) | (-t|--transform)) [FILE]`

`-r | --represent` načte ze vstupního souboru RV, uloží ho do své vnitřní reprezentace a nezměněný ho vypíše zpět na výstup

`-t | --transform` načte ze vstupního souboru RV, převede ho dle algoritmu (_I!!D!!!_) na RKA a vypíše ho na výstup

Není-li uveden vstupní soubor `[FILE]`, je uvažován standardní vstup (_stdin_)
___
## Závislosti a překlad 
Projekt pro zpracování argumentů příkazové řádky využívá knihovny **[optparse-applicative](https://github.com/pcapriotti/optparse-applicative)**, nainstalujete pomocí `cabal update && cabal install optparse-applicative`.

Pro linuxové distribuce s nainstalovaným GHC je možné příkazem `make` jednoduše přeložit celý projekt a následně ho spustit výše popsanou syntaxí. 

Pod systémem Microsoft Windows je třeba provést překlad pomocí `ghc Main.hs` a dále ho spouštět stejně.

## Algoritmus převodu RV na RKA

Pro převod regulární RV na RKA je využito algoritmu z [opory k předmětu TIN](http://www.fit.vutbr.cz/study/courses/TIN/public/Texty/oporaTIN.pdf). Implementace dále automat neminimalizuje a ponechává epsilon přechody.

## Implementované rozšíření pro vykreslování RKA

V rámci snahy o získání bonusových bodů jsem se rozhodl implementovat rozšíření, které umožní vytvářený RKA vizualizovat. Rozšíření je realizováno jako přepínač `-d | --transform-draw`, který se používá se stejnou syntaxí jako přepínače `-t|-r`.

Výstupem použitého přepínače `-d` je kód jazyka LaTeX, který po přeložení v prostředí s dostupným modulem `tikz` (je dostupný na školních serverech), vytvoří PDF obsahující získaný RKA. 

Příkazem:
 `./rv-2-rka -d TestData/test.input.1.in > TestLatex.tex | pdflatex TestLatex.tex` 
 je možné získat soubor TestLatex.pdf, v němž je vizualizován výsledný RKA.

Chtěl jsem se vyvarovat řešení kdy bych spouštěl `pdflatex` přímo z kódu projektu a to dělá získání obrázku automatu trochu krkolomné. Proto jsem do přiloženého `Makefile` připravil několik testovacích cílů, které na základě testovacích dat do složky `FSMImages` nagenerují automaty odpovídající regulárním výrazům z testovacích dat:

```
make drawFSM-1  				# Vytvoří obrázek pro 'a'
make drawFSM-2					# Vytvoří obrázek pro 'ab.'
make drawFSM-3					# Vytvoří obrázek pro RV ze zadání

make drawEverything				# Vše výše zmíněné naráz
```

## Vlastní testovací sada

Původně jsem měl napsané bashové skripty, kterými jsem svůj projekt průběžně testoval. Chtěl jsem to zaobalit do makefile (což jsem také z části udělal), ale v závěru to je stejné bezpečnostní riziko jako pouštět jakýkoliv jiný studentský bash soubor. V případě zájmu je možné přepsanou část testů spustit pomocí `make run-tests`.

Ve složce `TestData` jsou uloženy dvojice vstupů a výstpů, přičemž výstup je vždy pro přepínač `-t` (pro přepínač `-r` je očekávaný výstup stejný jako vstup. Přepínač `-d` není testován.
