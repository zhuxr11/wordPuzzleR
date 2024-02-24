# Main functions
#' @include utils.R
NULL

#' Run word puzzle game
#'
#' \code{run_game} is the main function to run word puzzle game.
#' The word puzzle game requires you to guess the word with single letters
#' in a limited times of trials. The letters you have guessed in the word
#' reveal themselves. If all letters are revealed before your guesses run out,
#' you win this round, otherwise you fail.
#'
#' @param mask_char (String) letter to mask the letters not guessed in the word.
#' @param verbose (Logical) whether to print welcome and score messages.
#' @param ... For internal use only.
#'
#' @return Named list of game stats invisibly, including:
#' \describe{
#'   \item{score}{Named integer with names as \code{success} (success rounds)
#'   and \code{total} (total rounds).}
#'   \item{best_guess}{Integer as the minimal number of guesses.}
#'   \item{best_hit}{Named integer with names as \code{hit} (guesses that hit
#'   any letters in the word) and \code{guess} (total guesses).}
#' }
#' @export
#'
#' @examples
#' # Run word puzzle game
#' if (interactive() == TRUE) {
#'   run_game()
#' }
run_game <- function(mask_char = "_", verbose = TRUE, ...) {
  stopifnot(nchar(mask_char) == 1L)
  if (verbose == TRUE) {
    message("========= Welcome to Word Puzzle in R =========")
  }
  score <- c(success = 0L, total = 0L)
  best_guess <- NA_integer_
  best_hit <- c(hit = 0L, guess = 0L)
  best_hit_rate <- NA_real_
  while (TRUE) {
    round_res <- .run_puzzle_round(mask_char = mask_char, verbose = verbose, ...)
    if (round_res[["success"]] == TRUE) {
      score[["success"]] <- score[["success"]] + 1L
      if ((is.na(best_guess) == TRUE) || (best_guess > round_res[["iter"]])) {
        best_guess <- round_res[["iter"]]
      }
      total_unique_letters <- length(unique(split_word(round_res[["word"]])))
      if ((is.na(best_hit_rate) == TRUE) ||
          (total_unique_letters / round_res[["iter"]] > best_hit_rate)) {
        best_hit <- c(hit = total_unique_letters, guess = round_res[["iter"]])
        best_hit_rate <- best_hit[["hit"]] / best_hit[["guess"]]
      }
    }
    score[["total"]] <- score[["total"]] + 1L
    if (verbose == TRUE) {
      message("Game stats:")
      message("* Current score: ", score[["success"]], "/", score[["total"]],
              " (", scales::percent(score[["success"]] / score[["total"]], accuracy = 0.01), ")")
      if (is.na(best_guess) == FALSE) {
        message("* Best guess: ", best_guess)
      }
      if (is.na(best_hit_rate) == FALSE) {
        message("* Best hit rate: ", best_hit[["hit"]], "/", best_hit[["guess"]],
                " (", scales::percent(best_hit_rate, accuracy = 0.01), ")")
      }
    }
    args_list <- list(...)
    if ((".auto" %in% names(args_list) == FALSE) || (as.logical(args_list[[".auto"]]) == FALSE)) {
      proceed <- readline("Proceed with a new word? [Y/N] ")
      if (any(c("N", "n") %in% proceed == TRUE)) break
    } else {
      if ((".round" %in% names(args_list) == FALSE) || (as.numeric(args_list[[".round"]]) <= 0)) {
        message("Proceed with a new word? [Y/N] N")
        break
      } else {
        message("Proceed with a new word? [Y/N] Y")
      }
    }
  }
  invisible(list(score = score, best_guess = best_guess, best_hit = best_hit))
}

#' One round of word puzzle
#' @noRd
.run_puzzle_round <- function(mask_char, verbose, .auto = FALSE, .letters = NULL) {
  target_word <- sample(.dict, size = 1L)
  word_mask <- rep(FALSE, nchar(target_word))
  success <- FALSE
  guess_pool <- c()
  for (cur_guess in seq_len(.wordPuzzleConfig[["guess"]])) {
    message("Guess: ", cur_guess)
    message("Word: ", mask_word(word = target_word, mask = word_mask, char = mask_char))
    while (TRUE) {
      if (.auto == FALSE) {
        input_char <- tolower(readline("Input a letter: "))
      } else {
        if (is.null(.letters) == TRUE) {
          .letters <- letters
        }
        input_char <- sample(setdiff(.letters, guess_pool), size = 1L)
        message("Input a letter: ", input_char)
      }
      if (nchar(input_char) == 1L) {
        if (input_char %in% guess_pool == TRUE) {
          message("! You have already guessed this letter")
        } else {
          guess_pool <- c(guess_pool, input_char)
          break
        }
      } else {
        message("! You should input a single letter")
      }
    }
    word_mask_new <- update_mask(word = target_word, cur_mask = word_mask, letter = input_char)
    if (sum(word_mask_new) > sum(word_mask)) {
      message("* Your guess hit ", sum(word_mask_new) - sum(word_mask), " letter(s) in the word!")
    } else {
      message("* Your guess hit no letters in the word! Better luck next time~")
    }
    word_mask <- word_mask_new
    if (all(word_mask == TRUE)) {
      success <- TRUE
      break
    }
  }
  if (success == TRUE) {
    message("You guessed the word [", target_word, "] in ", cur_guess, " guess(es)! Good job!")
  } else {
    message("You failed to guess the word! The answer is: ", target_word)
  }
  invisible(list(word = target_word, success = success, iter = cur_guess))
}
