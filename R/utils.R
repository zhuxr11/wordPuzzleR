# Functions to run at start/end of package
#' @include zzz.R
#' @import purrr
NULL

#' Configure wordPuzzleR
#'
#' \code{config_game} configures wordPuzzleR, or show current configuration
#' when used with no arguments.
#'
#' @importFrom utils assignInMyNamespace
#'
#' @param ... Arguments passed on to configurations. Valid names may be:
#' \describe{
#'   \item{dict}{(String) path to dictionary file, where each line is a word.}
#'   \item{min_len}{(Integer) minimal word length, default 3.}
#'   \item{max_len}{(Integer) maximal word length, default 8.}
#'   \item{guess}{(Integer) maximal guesses, default 10.}
#'   \item{pattern}{(String) Regular expression to filter qualified words,
#'   default "\[A-Za-z\]+".}
#' }
#' @param .verbose (Logical) whether config messages should be printed.
#'
#' @return Named list of new configurations, invisibly.
#' @export
#'
#' @examples
#' # Show current config
#' config_game()
config_game <- function(..., .verbose = TRUE) {
  args_list <- list(...)
  new_config <- purrr::reduce2(
    args_list,
    names(args_list),
    function(cur_config, value, name) {
      res <- cur_config
      if (name %in% names(.wordPuzzleConfig) == TRUE) {
        res[[name]] <- value
      } else {
        stop("Invalid config term: ", name)
      }
      res
    },
    .init = .wordPuzzleConfig
  )
  if (new_config[["guess"]] <= 0L) {
    stop("[guess] should be a positive integer")
  }
  utils::assignInMyNamespace(".wordPuzzleConfig", new_config)
  if (.verbose == TRUE) {
    message("wordPuzzleR config:")
    purrr::iwalk(
      new_config,
      ~ message("* ", .y, ": ", .x)
    )
  }
  prep_dict(config = new_config, verbose = .verbose)
  invisible(new_config)
}

#' Split word into letters
#' @noRd
split_word <- function(word) {
  stopifnot(length(word) == 1L)
  stringr::str_extract_all(word, ".")[[1L]]
}

#' Update word mask
#' @noRd
update_mask <- function(word, cur_mask, letter) {
  word_split <- split_word(word)
  (tolower(word_split) %in% tolower(letter) == TRUE) | (cur_mask == TRUE)
}

#' Mask letters without correct guess
#' @noRd
mask_word <- function(word, mask, char = "_") {
  word_split <- split_word(word)
  word_split_mask <- word_split
  word_split_mask[mask == FALSE] <- char
  paste(word_split_mask, collapse = "")
}
