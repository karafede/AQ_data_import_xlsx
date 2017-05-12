

library(magrittr)

yr=2016
is <- (mod(yr,400)==0 | mod(yr,4)==0) & mod(yr,100)!=0
