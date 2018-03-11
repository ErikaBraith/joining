---
title: "Joining dataframes in R using dplyr"
author: "Erika Braithwaite, PhD"
date: "March 15, 2018"
output:
  beamer_presentation: default
  slidy_presentation: default
  ioslides_presentation: default
incremental: yes
subtitle: RLadies Montreal
theme: metropolis
header-includes:
- \usepackage{tikz}
- \usepackage{pgfplots}
- \usepackage{graphicx}
- \usepackage{bm}
- \usepackage{amsmath}
- \usepackage{amssymb}
- \usepackage{mathtools}
- \usetikzlibrary{shadows,shapes,arrows,automata,calc,shapes.geometric,shapes.multipart,positioning,trees}
---


# What is joining?

We often run into scenarios where we need to join two dataframes together. Let's say we had some students who were given an IQ test at a career fair. Some of the students showed up at on both days, but not all. They were given unique alphanumeric identifiers.

Set up

```r
#install.packages('pacman')
pacman::p_load(knitr, kableExtra, formattable, data.table, dplyr,  rmarkdown)
```

Make some data 


```r
day1 =  data.table(ID=LETTERS[1:12],
                 IQ=round(rnorm(12, 100, 15),2))

day2 =  data.table(ID=LETTERS[6:17],
                 IQ=round(rnorm(12, 100, 20),2))
```

# Our data   


```r
kable(list(day1, day2), 'html') %>% 
        kable_styling(full_width = F, font_size = 14)
```

<table class="kable_wrapper table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
<tbody>
  <tr>
   <td> 

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> ID </th>
   <th style="text-align:right;"> IQ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 93.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 82.54 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 74.53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D </td>
   <td style="text-align:right;"> 114.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> E </td>
   <td style="text-align:right;"> 74.33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 87.11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> G </td>
   <td style="text-align:right;"> 81.42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> H </td>
   <td style="text-align:right;"> 107.71 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> I </td>
   <td style="text-align:right;"> 113.88 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> J </td>
   <td style="text-align:right;"> 113.76 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> K </td>
   <td style="text-align:right;"> 110.13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> L </td>
   <td style="text-align:right;"> 107.80 </td>
  </tr>
</tbody>
</table>

 </td>
   <td> 

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> ID </th>
   <th style="text-align:right;"> IQ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 106.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> G </td>
   <td style="text-align:right;"> 92.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> H </td>
   <td style="text-align:right;"> 91.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> I </td>
   <td style="text-align:right;"> 99.29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> J </td>
   <td style="text-align:right;"> 115.30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> K </td>
   <td style="text-align:right;"> 90.55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> L </td>
   <td style="text-align:right;"> 84.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> M </td>
   <td style="text-align:right;"> 49.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> N </td>
   <td style="text-align:right;"> 137.48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> O </td>
   <td style="text-align:right;"> 94.60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P </td>
   <td style="text-align:right;"> 123.68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Q </td>
   <td style="text-align:right;"> 100.25 </td>
  </tr>
</tbody>
</table>

 </td>
  </tr>
</tbody>
</table>

# Three(ish) types of joins in dplyr 

If we wanted to merge the two dataframes together, we can use dplyr's joining functions:

1. Mutating join: add a new variables to one table from matching rows in another

        left_join
        right_join
        inner_join

2. Filtering join: filter observations from one tables based on whether they match 

        full_join
        semi_join
        anti_join

3. Set operations: 
        
        intersect
        union
        setdiff

# Mutating joins 


```r
left = left_join(day1, day2, by = 'ID')
right = right_join(day1, day2, by = 'ID')
inner= inner_join(day1, day2, by = 'ID')
full = full_join(day1, day2, by = 'ID')
semi = semi_join(day1, day2, by = 'ID')
anti = anti_join(day1, day2, by = 'ID')
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> ID </th>
   <th style="text-align:right;"> IQ.x </th>
   <th style="text-align:right;"> IQ.y </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 87.11 </td>
   <td style="text-align:right;"> 106.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> G </td>
   <td style="text-align:right;"> 81.42 </td>
   <td style="text-align:right;"> 92.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> H </td>
   <td style="text-align:right;"> 107.71 </td>
   <td style="text-align:right;"> 91.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> I </td>
   <td style="text-align:right;"> 113.88 </td>
   <td style="text-align:right;"> 99.29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> J </td>
   <td style="text-align:right;"> 113.76 </td>
   <td style="text-align:right;"> 115.30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> K </td>
   <td style="text-align:right;"> 110.13 </td>
   <td style="text-align:right;"> 90.55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> L </td>
   <td style="text-align:right;"> 107.80 </td>
   <td style="text-align:right;"> 84.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> M </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 49.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> N </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 137.48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> O </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 94.60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 123.68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Q </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 100.25 </td>
  </tr>
</tbody>
</table>
 
# dplyr versus data.table versus base R

## data.table


```r
rbind(...,use.names = T, fill = F, idcol = NULL)
```

## Base R 

```r
rbind(...,deparse.level = 1, make.row.names = T)
```


```r
cbind()
```

```
## NULL
```


# When joining can get tricky... 
- Joining with columns having the same name but different encoding (UTF-8 vs. Latin)
- Joining with columns having different storage types (factors, integers, bit64, dates)
- 

# How to choose?

Dplyr has come a long way in terms of speed. Recent benchmarking conducted in Stack Overflow showed that dplyr starts to substantially lag when there are a large number of groups (>100k). 


While this point is contentious, if you've been a long standing tidyversalist, then you might find data.table's syntax more difficult to learn.   


# More!

There are additional types of joins not covered here: rolling joins, scaling joins

Rolling joins are used in circumstances where you want to map a dataframe to another based but you lack a common ID e.g. merging 
Resources



# Thank-you 

\small
\textbf{Committee member \& unofficial 3rd supervisor} \newline
Dr. Gavin Shaddick, University of Bath, Dept Math   

\vspace{2mm}
\textbf{Supervisors} \newline
Dr. David Buckeridge, McGill EBOH \newline
Dr. Sarah Henderson, BCCDC \& UBC SPPH 

\vspace{2mm}

Dr. Finn Lindgren, INLA research & development team 

\vspace{2mm}

British Columbia Centre for Disease Control (BCCDC)  

\vspace{2mm}

McGill Surveillance Lab

\vspace{5mm}

\definecolor{tempcolor2}{HTML}{ADCAB4}
\setbeamercolor{tealbox}{bg=tempcolor2!75}
\begin{beamercolorbox}[sep=1mm]{tealbox}
\footnotesize
Morrison KT, Shaddick G, Henderson SB, Buckeridge DL. 2016. `A latent process model for forecasting multiple time series in environmental public health surveillance.' \emph{Statistics in Medicine.} DOI: 10.1002/sim.6904
\end{beamercolorbox}

