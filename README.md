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

Before running the app, prepare the three required `.rds` datasets:

- household survey data
- auxiliary covariates
- shapefiles/geometries as an `sf` object

The files can be saved anywhere on your computer. In the dashboard, use the
Data inputs Browse buttons to select the three files. The variable mapping
fields then show searchable dropdowns based on the selected datasets, while
still allowing users to type a column name directly.

If you click `Save Current Setup`, the dashboard stores local setup copies of
selected files under `app_runs/_last_setup_files` so `Load Last Setup` can
restore the previous selections in the next session.

## Included Runtime Files

- `app.R`, `app_support.R`, `install_packages.R`, and `report.Rmd`
- `R/`, `scripts/`, `data/`, and `www/`
- Empty `outputs/` folders for generated reports, tables, data, and figures
- `Guidance note/`
- `LICENSE`, `.gitignore`, and `.gitattributes`

Generated files are written to `outputs/` and run logs are written to `app_runs/`. These are ignored by Git and can be regenerated.
