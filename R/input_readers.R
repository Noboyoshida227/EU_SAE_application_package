# ============================================================
# input_readers.R -- Shared data readers for dashboard inputs
# ============================================================

if (!exists("%||%", mode = "function")) {
  `%||%` <- function(x, y) {
    if (is.null(x) || length(x) == 0) y else x
  }
}

sae_file_ext <- function(path) {
  tolower(tools::file_ext(path %||% ""))
}

sae_single_object_from_rdata <- function(path, label = "input file") {
  load_env <- new.env(parent = emptyenv())
  loaded <- load(path, envir = load_env)
  if (length(loaded) != 1) {
    stop(label, " .RData/.rda file must contain exactly one object.", call. = FALSE)
  }
  load_env[[loaded[1]]]
}

sae_simplify_imported_columns <- function(x) {
  x <- as.data.frame(x, stringsAsFactors = FALSE)
  for (col in names(x)) {
    if (inherits(x[[col]], c("haven_labelled", "labelled"))) {
      x[[col]] <- as.vector(x[[col]])
    }
  }
  x
}

sae_read_table_input <- function(path, label = "input file") {
  if (is.null(path) || !nzchar(path %||% "") || !file.exists(path)) {
    stop(label, " does not exist: ", path %||% "(blank)", call. = FALSE)
  }
  ext <- sae_file_ext(path)
  out <- switch(
    ext,
    rds = readRDS(path),
    rda = sae_single_object_from_rdata(path, label),
    rdata = sae_single_object_from_rdata(path, label),
    csv = utils::read.csv(path, check.names = FALSE, stringsAsFactors = FALSE),
    txt = utils::read.csv(path, check.names = FALSE, stringsAsFactors = FALSE),
    tsv = utils::read.delim(path, check.names = FALSE, stringsAsFactors = FALSE),
    dta = {
      if (!requireNamespace("haven", quietly = TRUE)) {
        stop("Package 'haven' is required to read Stata .dta files. Run install_packages.R and try again.", call. = FALSE)
      }
      haven::read_dta(path)
    },
    xlsx = {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        stop("Package 'readxl' is required to read Excel files. Run install_packages.R and try again.", call. = FALSE)
      }
      readxl::read_excel(path)
    },
    xls = {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        stop("Package 'readxl' is required to read Excel files. Run install_packages.R and try again.", call. = FALSE)
      }
      readxl::read_excel(path)
    },
    stop(
      "Unsupported ", label, " format: .", ext,
      ". Accepted tabular formats are .rds, .RData/.rda, .csv, .tsv, .txt, .dta, .xlsx, and .xls.",
      call. = FALSE
    )
  )
  sae_simplify_imported_columns(out)
}

sae_read_geometry_input <- function(path, label = "geometry file") {
  if (is.null(path) || !nzchar(path %||% "") || !file.exists(path)) {
    stop(label, " does not exist: ", path %||% "(blank)", call. = FALSE)
  }
  ext <- sae_file_ext(path)
  if (ext %in% c("rds", "rda", "rdata")) {
    return(if (ext == "rds") readRDS(path) else sae_single_object_from_rdata(path, label))
  }
  if (!requireNamespace("sf", quietly = TRUE)) {
    stop("Package 'sf' is required to read spatial files. Run install_packages.R and try again.", call. = FALSE)
  }
  spatial_path <- path
  if (identical(ext, "zip")) {
    unzip_dir <- file.path(tempdir(), paste0("sae_geometry_", tools::file_path_sans_ext(basename(path)), "_", Sys.getpid()))
    dir.create(unzip_dir, recursive = TRUE, showWarnings = FALSE)
    utils::unzip(path, exdir = unzip_dir)
    candidates <- list.files(
      unzip_dir,
      pattern = "\\.(shp|gpkg|geojson|json|kml|gml)$",
      recursive = TRUE,
      full.names = TRUE,
      ignore.case = TRUE
    )
    if (length(candidates) == 0) {
      stop("Zipped geometry file must contain a .shp, .gpkg, .geojson, .json, .kml, or .gml file.", call. = FALSE)
    }
    shp_first <- grep("\\.shp$", candidates, ignore.case = TRUE, value = TRUE)
    spatial_path <- if (length(shp_first) > 0) shp_first[1] else candidates[1]
  } else if (!ext %in% c("shp", "gpkg", "geojson", "json", "kml", "gml")) {
    stop(
      "Unsupported ", label, " format: .", ext,
      ". Accepted geometry formats are .rds, .RData/.rda, .zip shapefile, .shp, .gpkg, .geojson, .json, .kml, and .gml.",
      call. = FALSE
    )
  }
  sf::st_read(spatial_path, quiet = TRUE)
}

sae_read_input_names <- function(path, kind = c("table", "geometry")) {
  kind <- match.arg(kind)
  if (is.null(path) || !nzchar(path %||% "") || !file.exists(path)) {
    return(character())
  }
  obj <- tryCatch({
    if (identical(kind, "geometry")) {
      sae_read_geometry_input(path)
    } else {
      ext <- sae_file_ext(path)
      if (ext == "csv") {
        return(names(utils::read.csv(path, nrows = 0, check.names = FALSE)))
      }
      if (ext == "tsv") {
        return(names(utils::read.delim(path, nrows = 0, check.names = FALSE)))
      }
      if (ext == "dta" && requireNamespace("haven", quietly = TRUE)) {
        return(names(haven::read_dta(path, n_max = 0)))
      }
      sae_read_table_input(path)
    }
  }, error = function(e) NULL)
  unique(trimws(as.character(names(obj) %||% colnames(obj) %||% character())))
}
