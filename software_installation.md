# Software Installation Instructions

## Windows
If you are on Windows, you will have to install most of the software manuall. Alternatively, you can use a package manager such as [*Chocolatey*](https://chocolatey.org/) to install some of the tools. In order to install the required R packages hassle-free, run the following line of code in R:

```R
source("https://raw.githubusercontent.com/retrography/digital-methods/master/setup.R")
```

## macOS
If you are on macOS, you can use *homebrew* to install all the required software:

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/cask
brew install git
brew cask install r-app rstudio openrefine gephi
Rscript -e 'source("https://raw.githubusercontent.com/retrography/digital-methods/master/setup.R")'
```

## Linux
The required software are all free and most can be obtained through your distro's official package manager (such as aptitude). In order to install the required R packages hassle-free, run the following line of code in R:

```R
source("https://raw.githubusercontent.com/retrography/digital-methods/master/setup.R")
```

