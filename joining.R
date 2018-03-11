# template for joining slides

install.packages('pacman')
library(pacman)

pacman::p_load(data.table, dplyr, tinytex, knitr)

day1 =  data.table(ID=LETTERS[1:12],
                 y=round(rnorm(4),4))

df =  data.table(ID=LETTERS[1:12],
                 V3=round(rnorm(4),4),
                 V4=1:12)

&&
        

