# onLoad functions
#' @import stringr
NULL

.PKG_NAME <- ""

.wordPuzzleConfig <- list(
  dict = "",
  min_len = 3L,
  max_len = 8L,
  guess = 10L,
  pattern = "[A-Za-z]+"
)

.dict <- c()

#' Prepare dictionary
#' @importFrom utils assignInMyNamespace
#' @noRd
prep_dict <- function(config, verbose = TRUE) {
  .core_fun <- function(dict_path, min_len = 3L, max_len = 8L, pattern = "[A-Za-z]+", guess = 10L) {
    dict_raw <- readLines(dict_path)
    dict <- dict_raw
    dict <- dict[nchar(dict_raw) >= min_len & nchar(dict_raw) <= max_len]
    dict <- dict[stringr::str_extract_all(dict, pattern) == dict]
    if (length(dict) == 0L) {
      stop("No valid words loaded from dictionary",
           "; please check config with config_game()")
    }
    if (verbose == TRUE) {
      message("Loaded ", length(dict), " word(s) from dict")
    }
    dict
  }
  utils::assignInMyNamespace(".dict", do.call(.core_fun, config))
}

#' @importFrom utils assignInMyNamespace
#' @noRd
.onLoad <- function(...) {
  args_list <- list(...)
  utils::assignInMyNamespace(".PKG_NAME", args_list[[2L]])
  init_config <- .wordPuzzleConfig
  init_config[["dict"]] <- system.file(file.path("resources", "dict.txt"), package = .PKG_NAME)
  utils::assignInMyNamespace(".wordPuzzleConfig", init_config)
  prep_dict(config = .wordPuzzleConfig, verbose = FALSE)
}
