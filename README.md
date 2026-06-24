# EU SAE Application Package

This package contains the files needed to run the EU SAE Shiny dashboard, plus the `Guidance note/` folder.

## Run the Dashboard

Prerequisite: install R 4.2.0 or later from <https://cran.r-project.org/>.

On Windows:

```bat
Start_Dashboard.bat
```

On macOS or Linux:

```bash
bash Start_Dashboard.sh
```

The launcher checks for required R packages through `install_packages.R`, starts the dashboard, and opens it at the first available local port, usually:

```text
http://127.0.0.1:7777
```

If that port is already in use, the launcher prints and opens the next available URL, such as `http://127.0.0.1:7778`.

Keep the terminal or launcher window open while using the dashboard.

## Data Files

Before running the app, place all three required `.rds` datasets in the package
`data/` subfolder:

- household survey data
- auxiliary covariates
- shapefiles/geometries as an `sf` object

File names can be anything. In the dashboard, choose the three files from the
Data inputs dropdowns, or use the upload buttons to select files directly.

## Included Runtime Files

- `app.R`, `app_support.R`, `install_packages.R`, and `report.Rmd`
- `R/`, `scripts/`, `data/`, and `www/`
- Empty `outputs/` folders for generated reports, tables, data, and figures
- `Guidance note/`
- `LICENSE`, `.gitignore`, and `.gitattributes`

Generated files are written to `outputs/` and run logs are written to `app_runs/`. These are ignored by Git and can be regenerated.
