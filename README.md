# r-intro-book

[![Travis
(.org)](https://img.shields.io/travis/tadaadata/r-intro-book.svg?logo=travis)](https://travis-ci.org/tadaadata/r-intro-book)

Eine ausführlichere Version der R-Einfürhung für QM.

Das Output wird nach [https://r-intro.tadaa-data.de/book](https://r-intro.tadaa-data.de/book/) geschoben und sollte da auch funktionieren.

Das Format ist [bookdown](https://bookdown.org/yihui/bookdown/usage.html), und zumindest was das schreiben angeht ist das Ganze auch relativ simpel. Einfach für jedes Kapitel ein `.Rmd` anlegen, an die naming convention mit der Kapitelnummer am Beginn des Dateinamens halten, und dann ist es mehr oder weniger ganz normales RMarkdown.  
Installation via `install.packages("bookdown")`.  

Das Projekt wird automatisch via [travis](https://travis-ci.org/tadaadata/r-intro-book) gebaut und auf unseren Webserver geschoben, wenn ein neuer Commit auf GitHub landet – manuell gebaut werden muss also nichts, außer zum lokalen Ausprobieren.

## Build

Das build script (`build.R`) sollte die notwendigen R-packages installieren, aber system dependencies werden da nicht abgefrühstückt.

Um das Ganze auf Ubuntu (xenial) zu bauen, sollten ein paar dependencies gegeben sein:

```bash
sudo apt install libcurl4-openssl-dev curl git libxml2-dev libcairo2-dev xvfb
```
