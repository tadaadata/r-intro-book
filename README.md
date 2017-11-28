# r-intro-book

Eine ausführlichere Version der R-Einfürhung für QM.

Das Output wird nach [https://r-intro.tadaa-data.de/book](https://r-intro.tadaa-data.de/book/) geschoben und sollte da auch funktionieren.

Das Format ist [bookdown](https://bookdown.org/yihui/bookdown/usage.html), und zumindest was das schreiben angeht ist das Ganze auch relativ simpel. Einfach für jedes Kapitel ein `.Rmd` anlegen, an die naming convention mit der Kapitelnummer am Beginn des Dateinamens halten, und dann ist es mehr oder weniger ganz normales RMarkdown.  
Installation via `install.packages("bookdown")`.  

Um das Ganze auf Ubuntu zu bauen, sollten ein paar dependencies gegeben sein:

```bash
sudo apt install libcurl4-openssl-dev curl git libxml2-dev libcairo2-dev xvfb calibre
``´

Wenn du entweder ich oder Tobi bist, sollte ein `build` reichen um ein Update auf die Website zu starten, ansonsten, äh… tu Dinge mit git und mach einen Pull Request oder sowas. You get the idea.
