# My R Project Template
My own R Project Template. Feel free to copy and use.

Inspired by the [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/) project
structure, this project template presents a good starting project structure for any new R
project. I created this repo to be used in my data science work at
[Synapse Analytics](https://www.synapse-analytics.io/).

Additional settings that I typically set are as follows:
* Tools > Global Options > Code > Editing > Insert spaces for tab: Yes
* Tools > Global Options > Code > Editing > Tab Width: 4
* Tools > Global Options > Code > Saving > Ensure that source files end with newline: Yes
* Tools > Global Options > Code > Saving > Strip trailing horizontal whitespace when saving

Assuming you have the `styler` package installed, do the following before committing in Git:
* Tools > Addins > Browse Addins > "styler - Set style" > `styler::tidyverse_style(indent_by = 4)`
* Tools > Addins > Browse Addins > "styler - Set active file"

Finally, if there is a different folder or file that you feel like adding later, you may
want to make sure that ***it has no spaces and is all lowercase with underscores!***
