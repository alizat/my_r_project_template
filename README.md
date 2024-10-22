# My R Project Template
*My own R Project Template. Feel free to copy and use.*

----

## Intro

Inspired by the [Cookiecutter Data
    Science](https://drivendata.github.io/cookiecutter-data-science/) project
structure, this project template presents a good starting project structure for
any new R project. I created this repo to be used in my data science work at
[Synapse Analytics](https://www.synapse-analytics.io/).

----

## Conventions

RStudio settings that I typically set are as follows:

* Tools
    * Global Options
        * Code
            * Editing
                * check `Insert spaces for tab`
                * `Tab Width`: *4*
            * Display
                * check `Highlight selected line`
                * check `Allow scroll past end of document`
                * check `Highlight R function calls`
                * check `Use rainbow parentheses`
            * Saving
                * check `Ensure that source files end with newline`
                * check `Strip trailing horizontal whitespace when saving`
            * Completion
                * `Show code completions` = *When Triggered ($, ::)*
            * Code
                * Diagnostics
                    * check everything! (except `Warn if variable has no definition in scope`)
    * Project Options
        * General
            * `Restore .RData into workspace at startup`: *No*
            * `Save workspace to .RData on exit`: *No*
            * `Always save history (even if not saving .RData)`: *Yes*
            * check `Disable .Rprofile execution on session start/resume`
            * check `Quit child processes on exit`
        * Code Editing
            * check `Ensure that source files end with newline`
            * check `Strip trailing horizontal whitespace when saving`

Assuming you have the `styler` package installed, do the following before committing in Git:
* Tools > Addins > Browse Addins > `styler - Set style` > *styler::tidyverse_style(indent_by = 4)*
* Tools > Addins > Browse Addins > `styler - Set active file`

Finally, if there is a different folder or file that you feel like adding later, you may
want to make sure that ***it has no spaces and is all lowercase with underscores!***

----

## Modify this `README.md` file

You may modify this README file to mention the following:

* the project scope/purpose
* the data sources under `./data`
* what the different scripts do, how to use, where to start, etc.
* supplementary details: important links, contacts, etc.

----

## Modify `present_release.txt`

You may modify `present_release.txt` to contain the following: 

* general reason(s) why the code is being worked on nowadays
* details of current release such as latest changes, added features, fixed bugs, etc.
* current prediction performance, date when data was last updated, etc.

When it is time to push to GitHub/GitLab, you may do either of the following:

* simply push `present_release.txt` to GitHub/GitLab.
* include `present_release.txt` in `.gitignore`, push to GitHub/GitLab, and then add contents of `present_release.txt` as release notes for the latest version on GitHub/GitLab. 

After pushing to GitHub/GitLab, empty `present_release.txt` to make room for
details of the next release. Alternatively, you may simply update 
`present_release.txt` by appending the latest notes to the top of the file.

----

## Modify `.gitignore`

You may un-comment the last few lines in `.gitignore` so they would not be
tracked by Git anymore.

```
#code/logs/
#data/
#figures/
#rubbish/
#shiny/
#yesteryear/
```

----

## Directory structure

```
├── README.md           <- The top-level README for developers using this project.
├── present_release.txt <- notes regarding the current version of this project.
├── backlog.txt         <- TODOs for (much?) later, ideas to consider, etc.
├── .gitignore          <- files & folders to be ignored by Git.
│
├── code                <- Source code for use in this project.
│   |
│   ├── data_wrangling  <- Scripts to download or generate data
│   │   ├── dataset.R   <- retrieve and process data & prepare data set(s).
│   │   └── features.R  <- generate new features.
│   │
│   ├── eda             <- analyses on the data, including data summaries and visualizations.
│   │
│   ├── modeling        <- train models and then use trained models to make predictions.
│   │   ├── predict.R
│   │   └── train_model.R
│   │
│   ├── logs            <- to (optionally) store console output from executed scripts.
|   |                      e.g. [TERMINAL] nohup Rscript data_grabber.R > midnight_data_grab.log 2>&1 &
|   |                      e.g. using the sink() function in R
│   │
│   └── common_funcs.R  <- common functions that are used across projects.
│
├── data
│   ├── raw             <- original, immutable data dump.
│   ├── processed       <- final data sets for analysis and modeling.
│   ├── external        <- data from third party sources (i.e. NOT from the client's side).
│   └── tmp             <- intermediate data that is temporary.
│
├── figures             <- generated graphics for reporting
│
├── models              <- train/val/test sets, trained models & prediction summaries.
│
├── rubbish             <- stuff you'll probably never need but wanna keep anyway.
│
├── shareables          <- files that were shared between us and the client, or internally.
│   ├── from_client     <- files shared from client to us.
│   ├── from_us         <- files shared from us to client.
│   └── internal        <- files shared internally.
│
├── shiny               <- where self-contained shiny apps live.
│   └── first_shiny_app <- an example shiny app (each shiny app to be in its own folder).
│
└── yesteryear          <- old scripts/data/figures.
```

----
