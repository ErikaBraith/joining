# template for joining slides

install.packages('pacman')
library(pacman)

pacman::p_load(data.table, dplyr, tinytex, knitr)

# Scenario 1 
day1 =  data.table(ID=LETTERS[1:12],
                 y1=round(rnorm(4),4))

day2 =  data.table(ID=LETTERS[6:17],
                 y2=round(rnorm(6),4))

day1
day2

left = left_join(day1, day2)
right = right_join(day1, day2)
inner= inner_join(day1, day2)
full = full_join(day1, day2)
semi = semi_join(day1, day2)
anti = anti_join(day1, day2)

        

