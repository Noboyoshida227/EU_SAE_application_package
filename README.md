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

The launcher checks for required R packages through `install_packages.R`, starts the dashboard, and opens it at:

```text
http://127.0.0.1:7777
```

Keep the terminal or launcher window open while using the dashboard.

## Included Runtime Files

- `app.R`, `app_support.R`, `install_packages.R`, and `report.Rmd`
- `R/`, `scripts/`, `data/`, and `www/`
- Empty `outputs/` folders for generated reports, tables, data, and figures
- `Guidance note/`
- `LICENSE`, `.gitignore`, and `.gitattributes`

Generated files are written to `outputs/` and run logs are written to `app_runs/`. These are ignored by Git and can be regenerated.
