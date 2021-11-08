#' ---
#' title: Lab 5
#' author: Boyoon Chang
#' date: "`r format(Sys.Date(), '%d %B %Y')`"
#' output: 
#'     html_document:
#'         keep_md: true
#' ---
#' 
#' # Set up

library(pacman)
p_load(tidyverse, nycflights13)

#' `nycflights13` is a database versions of nycflights 13 data. 
#' `flights` is an on-time data for all flights that departed NYC (i.e. JFK, LGA or EWR) in 2013.

#' ## Investigate the data
?nycflights13
?flights
head(flights)
names(flights)
glimpse(flights)
summary(flights)
dim(flights)

#' ## Review of Dplyr functions
#' 
#' ### filter
#' 
#' #### Logical Condition
flights$month[336776]==1
flights %>% filter(month==1)
#' #### Logical Operator
#' ##### |
flights %>% filter(month == 11 | month == 12)
#' ##### %in% 
flights %>% filter(month %in% c(11,12))
#' ##### &
flights %>% filter(month == 11 & day == 11)

#' 
#' ### mutate
#' 
flights %>% mutate(
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60
)

#' ### group_by/summarize

flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) 

#' ## Merging dataset
#' ### Try to merge two dataset
head(weather)
left_join(x=flights, y=weather) 
left_join(x=flights, y=weather, by = c("year", "month", "day", "hour", "origin")) 
names(weather)
names(flights)
testd1=tibble(
  var1=1:4,
  var2=2:5,
  var3=3:6,
  varA=4:7
)
testd1
testd2= tibble(
  varA=5:10,
  varB=11:16
)
testd2
testd1 %>% full_join(testd2)
testd1 %>% left_join(testd2)
testd1 %>% right_join(testd2)
testd1 %>% inner_join(testd2)

