#' ---
#'   title: "Problem Set 1" 
#'   author: "Boyoon Chang"
#' ---

library(tidyverse)
library(magrittr)

#' Question 3

data_q2 = tibble(
  id = 1:6, 
  treat_dum=c(1,1,1,0,0,0),
  y1=c(7,4,6,5,3,8),
  y0=c(1,7,2,9,3,2)
)

#' b

summarize(data_q2, mean(y1-y0))

#' d

data_q2 %>% group_by(treat_dum) %>% 
  summarize(mean(y1), mean(y0)) %>% 
  tibble() %>% c(ate_observed=.[[2,2]]-.[[1,3]]) 

#' Question 4

data_q4=tibble(
  tree=1:5,
  diameters= c(8.3, 10.5, 11.1, 14.2, 17.5), 
  height = c(70,72,80,80,82), 
  volume = c(10.3, 16.4, 22.6, 31.7, 55.7)
)

#' 4a
mean(data_q4$diameters)
#' 4b
var(data_q4$volume)
#' 4c
cor(data_q4$diameters, data_q4$volume)


#' Computational exercise
#' 1
data_q5 = read_csv("EC320_ps1.csv")
data_q5 %<>% mutate(trump_pct_votes = trump_votes/total_votes,
                    biden_pct_votes = biden_votes/total_votes,
                    trump_margin = trump_pct_votes - biden_pct_votes)

#' 2ab
data_q5 %>% select(trump_margin, pct_bachelors_degree, poverty_rate, population) %>%
  map(function(x) summarize(., min(x), max(x), mean(x), median(x), sd(x), n()))

sum_stat_function = function(data, var) {
  summarize(data, min(var),
              max(var),
              mean(var),
              sd(var),
              n()
            )
}

sum_stat_function(data_q5, data_q5$poverty_rate)

#' 2c

#group_by + slice doesn't work together well
#data_q5 %>% group_by(state, county) %>% arrange(desc(population)) %>% slice_head(n=1) 
#data_q5 %>% group_by(county) %>% arrange(desc(population)) %>% nrow()
data_q5 %>% arrange(desc(population)) %>% slice(c(1,nrow(.))) %>% select(county, population)

#' 3
library(ggplot2)
ggplot(data = data_q5, aes(x=trump_margin)) + geom_histogram()
sum(data_q5$trump_votes) > sum(data_q5$biden_votes)

#' 4
data_q5%>% ggplot(aes(x=poverty_rate, y = trump_margin)) + geom_point()

#' 5
data_q5%>% ggplot(aes(x=pct_bachelors_degree, y = trump_margin)) + geom_point()

#' 6
data_q5 %>% group_by(state) %>% 
  summarize(
    bachelor_degree = weighted.mean(pct_bachelors_degree),
    poverty = weighted.mean(poverty_rate),
    population_state = sum(population)
)

#' 7
data_q5 %>% group_by(state) %>% 
  summarize(
    bachelor_degree = weighted.mean(pct_bachelors_degree),
    poverty = weighted.mean(poverty_rate),
    population_state = sum(population)
  ) %>% 
  ggplot(aes(x=bachelor_degree, y = poverty)) + 
  geom_point(aes(size = population_state))
