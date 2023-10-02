
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Word Puzzle Game in R

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/wordPuzzleR)](https://CRAN.R-project.org/package=wordPuzzleR)
[![R-CMD-check](https://github.com/zhuxr11/wordPuzzleR/workflows/R-CMD-check/badge.svg)](https://github.com/zhuxr11/wordPuzzleR/actions)
[![Download
stats](https://cranlogs.r-pkg.org/badges/grand-total/wordPuzzleR)](https://CRAN.R-project.org/package=wordPuzzleR)
<!-- badges: end -->

**Package**: [*wordPuzzleR*](https://github.com/zhuxr11/wordPuzzleR)
0.1.0<br /> **Author**: Xiurui Zhu<br /> **Modified**: 2023-10-02
10:04:07<br /> **Compiled**: 2023-10-02 10:04:13

**Let’s have fun with R!** In this word puzzle game, you are required to
find out the letters in a word within a limited number of guesses. In
each round, if your guess hit any letters in the word, they reveal
themselves. If all letters are revealed before your guesses run out, you
win this game; otherwise you fail. You may run multiple games to guess
different words.

## Installation

You can install the released version of `wordPuzzleR` from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("wordPuzzleR")
```

Alternatively, you can install the developmental version of
`wordPuzzleR` from [github](https://github.com/) with:

``` r
remotes::install_github("zhuxr11/wordPuzzleR")
```

## Running word puzzle game

First, load the package with `library()` in R.

``` r
library(wordPuzzleR)
```

Then, you may start the word puzzle game with `run_game()`.

``` r
run_game()
```

    #> ========= Welcome to Word Puzzle in R =========
    #> Guess: 1
    #> Word: ________
    #> Input a letter: o
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 2
    #> Word: _o______
    #> Input a letter: i
    #> * Your guess hit no letters in the word! Better luck next time~
    #> Guess: 3
    #> Word: _o______
    #> Input a letter: e
    #> * Your guess hit 2 letter(s) in the word!
    #> Guess: 4
    #> Word: _o_e_e__
    #> Input a letter: g
    #> * Your guess hit no letters in the word! Better luck next time~
    #> Guess: 5
    #> Word: _o_e_e__
    #> Input a letter: t
    #> * Your guess hit no letters in the word! Better luck next time~
    #> Guess: 6
    #> Word: _o_e_e__
    #> Input a letter: d
    #> * Your guess hit no letters in the word! Better luck next time~
    #> Guess: 7
    #> Word: _o_e_e__
    #> Input a letter: b
    #> * Your guess hit no letters in the word! Better luck next time~
    #> Guess: 8
    #> Word: _o_e_e__
    #> Input a letter: l
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 9
    #> Word: _o_ele__
    #> Input a letter: k
    #> * Your guess hit no letters in the word! Better luck next time~
    #> Guess: 10
    #> Word: _o_ele__
    #> Input a letter: x
    #> * Your guess hit no letters in the word! Better luck next time~
    #> You failed to guess the word! The answer is: homeless
    #> Game stats:
    #> * Current score: 0/1 (0.00%)
    #> Proceed with a new word? [Y/N] N

Alternatively, you can use a different mask letter by specifying
`mask_char`.

``` r
run_game(mask_char = "*")
```

    #> ========= Welcome to Word Puzzle in R =========
    #> Guess: 1
    #> Word: ******
    #> Input a letter: e
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 2
    #> Word: **e***
    #> Input a letter: r
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 3
    #> Word: *re***
    #> Input a letter: i
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 4
    #> Word: *re*i*
    #> Input a letter: t
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 5
    #> Word: *re*it
    #> Input a letter: c
    #> * Your guess hit 1 letter(s) in the word!
    #> Guess: 6
    #> Word: cre*it
    #> Input a letter: d
    #> * Your guess hit 1 letter(s) in the word!
    #> You guessed the word [credit] in 6 guess(es)! Good job!
    #> Game stats:
    #> * Current score: 1/1 (100.00%)
    #> * Best guess: 6
    #> * Best hit rate: 6/6 (100.00%)
    #> Proceed with a new word? [Y/N] N

## Configuring word puzzle game

The word puzzle game can be configured with `config_game()`.

``` r
config_game(
  # Set dictionary path
  dict = system.file(file.path("resources", "dict.txt"), package = "wordPuzzleR"),
  # Set word lengths (min/max)
  min_len = 3L,
  max_len = 8L,
  # Set maximal guesses
  guess = 10L,
  # Set word pattern (regular expression)
  pattern = "[A-Za-z]+"
)
#> wordPuzzleR config:
#> * dict: F:/Projects/Packages/wordPuzzleR/inst/resources/dict.txt
#> * min_len: 3
#> * max_len: 8
#> * guess: 10
#> * pattern: [A-Za-z]+
#> Loaded 2400 word(s) from dict
```
