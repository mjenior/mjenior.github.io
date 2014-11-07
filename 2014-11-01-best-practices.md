---
layout: post
title:  "Best practices"
date:   2014-11-01 13:55:47
comments: true
---

Let's discuss and be open to evolving a set of best practices for fostering an
reproducible environment for doing microbial informatics.

### Reproducibility
You will undoubtedly run the same analysis multiple times. Either because you
find a bug, I make a suggestion, or we get more data. The ability to automate a
reproducible workflow saves a considerable amount of time and headache.
Futhermore, when we are ready to submit a paper, it should be possible to go
into an empty folder, execute a `write.paper`-type of command, and generate the
text, tables, and figures of your paper.

### Repositories
Every project needs its own repository on your or our lab's GitHub account. At a
minimum, that repository should include be a brief `README.md` file that
describes what the project is about, an MIT license, a .gitignore file, and a
`*.Rmd` and `*.md` file. There is no reason to store intermediary files in your
repository since these are quite large and can be easily reproduced (assuming
you are striving for reproducibility).

### Data
All data should be viewed as read only. The original files should be accessible
and if the contents need to be altered, then the alterations should occur in a
secondary file and there should be a script that details the alterations.

### Protected Health Information (PHI)
No PHI should be posted to the internet.

### Get organized
You should not have a single folder with thousands of files in it. Large
directories bog down your computer and make it difficult to track which files
are relevant

### Commit frequency
After the initial commit for a file, each commit should only include changing
one thing. If you were to tell someone what was done in the commit would you
use the word 'and'? If so, then you need to break apart the commit or strive
for cleaner commits.

### Push frequency
At least once a day

### Commit messages
1. First line should be an imperative statement that is less than 50 characters
long. Capitalize first word and do not put a period at the end.
2. Second line should be white space
3. Subsequent lines should be no more than 72 characters long and provide a
detailed description of the original problem, what was done to solve it, and any
possible limitations.
4. Include references to issue tracking

### Working in style
People have their own idiosyncrasies about how they format their code. Hadley
Wickham has developed an [R style guide](http://r-pkgs.had.co.nz/style.html)
that is based on google's that is worth considering if you haven't developed
your own bad habits yet. Some critical themes to consider (some plagiarism
of Wickham follows):

* File names, variable names, and function names should all be meaningful and
self commenting
* Avoid variable and function names that are already used by R (e.g. `c`, `T`)
* Place spaces around all operators (=, +, -, <-, etc.) and a space after a
comma
* An opening curly brace should never go on its own line and should always be
followed by a new line. A closing curly brace should always go on its own line,
unless it’s followed by else. Always indent the code inside curly braces.
* Strive to limit your code to 80 characters per line. This fits comfortably on
a printed page with a reasonably sized font. If you find yourself running out
of room, this is a good indication that you should encapsulate some of the
work in a separate function.
* When indenting your code, use two spaces. Never use tabs or mix tabs and
spaces.
* Use <-, not =, for assignment.
* Function names should be verbs, where possible and the function should be no
more than 50 lines
* Comment your code liberally. Each line of a comment should begin with the
comment symbol and a single space. They should explain the why, not the what.

### knitr
* All code chunks need to be named
* Set `echo=T`
* cache=?  
* How much sourcing should we have within each document vs. imbedded functions?  



These best practices are an evolving target that may need to be revised with
experience. If you have a suggestion, please make a pull request and we can
iterate.
