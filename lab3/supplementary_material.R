#' ---
#' title: Comprehensive Overview of R
#' author: Boyoon Chang
#' date: "`r format(Sys.Date(), '%d %B %Y')`"
#' ---

#' ***
#' ## 1. Review of R 
#' ### Install and load the packages
#' - If it's your first time using the package, you are most likely to have not installed it. Then run `install.packages("<packageName>")`. ( Replace <packageName> with the actual name of the package, i.e. `install.packages("tidyverse")` )
#' - Installation and loading it is two separate thing, just like you need to click on the software to initialize it after installing it on your laptop, you need to run `library()` to load the package on your R studio. (i.e., `library('tidyverse')`)
#' 

#' ### What are packages?
#' 
#' 'R packages are collection of **functions** and **data sets** developed by the community' [Retrieved from here](https://www.datacamp.com/community/tutorials/r-packages-guide)
#' 
#' ### What is a function? 
#' 
#' - Examples: print(), ggplot(), select(), filter(), etc.
#' - Let's create one!
addition = function(param1, param2){
  result = param1+param2
  return(result)
}
# param1, param2 are referred to as parameters of the addition function.
addition(param1=1,param2=2)
# 1 and 2 are referred to as the arguments of the call.
subtraction = function(banana, apple){
  result = banana-apple
  return(result)
}
# By default, unless specified otherwise, banana=2, apple=3 because banana comes before apple in the order of parameters in the function.
subtraction(banana=2, apple=3)
subtraction(2,3)
# If we are declaring the parameter with argument, order doesn't matter.
subtraction(apple=2,banana=3)
print
library(gapminder)
library(ggplot2)
geom_vline
aes
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp)) + geom_point()
# Following code won't run.
# ggplot(aes(x=gdpPercap, y=lifeExp), gapminder) + geom_point()
ggplot(mapping=aes(x=gdpPercap, y=lifeExp), data = gapminder) + geom_point()

#' ***
#' ## 2. Review of ggplot
#'  
library(ggplot2)
ggplot(data = gapminder, mapping=aes(x=gdpPercap, y=lifeExp))
ggplot(data = gapminder, mapping=aes(x=gdpPercap, y=lifeExp)) +
  geom_point()
ggplot(data = gapminder, mapping=aes(x=gdpPercap, y=lifeExp)) +
  geom_point()+
  geom_smooth()
ggplot(data = gapminder, mapping=aes(x=gdpPercap, y=lifeExp)) +
  geom_point()+
  geom_smooth(se=FALSE)
ggplot(data = gapminder, mapping=aes(x=gdpPercap, y=lifeExp)) +
  geom_point()+
  geom_smooth(method="lm")
ggplot(data = gapminder, mapping=aes(x=gdpPercap)) +
  geom_histogram()
ggplot(data = gapminder, mapping=aes(x=gdpPercap)) +
  geom_density()
ggplot(data = gapminder, mapping=aes(x=gdpPercap, color=continent, fill=continent)) +
  geom_density(alpha=0.3)
ggplot(data = gapminder, mapping=aes(y=lifeExp, 
                                     x=gdpPercap, 
                                     color=continent)) + 
  geom_point()
ggplot(data = gapminder, mapping=aes(y=lifeExp, 
                                     x=gdpPercap, 
                                     color=continent, 
                                     shape=continent)) + 
  geom_point()
ggplot(data = gapminder, mapping=aes(y=lifeExp, 
                                     x=gdpPercap, 
                                     color=continent, 
                                     shape=continent)) + 
  geom_point()+
  geom_smooth()

#' ***
#' ## 3. Import data externally
#' 
#' ### Load tidyverse
library(tidyverse)

#' ### read_csv() function in tidyverse package
#' 
#' - R will look for the file called 'lab2.csv'
#' - But where is the lab2.csv? 
#' - We need to specify the location of this file, such that R knows where to look for the file.
# Below code won't run because R doesn't know which folder to look at for lab2.csv.
# our_data <- read_csv("lab2.csv") 
# could do this if you set working directory to the folder that lab2.csv is in OR
cps <- read_csv('/Users/boyoonc/ec320_labs/lab3/lab3.csv')

#' ***
#' ## 4. Data analysis
#' 
#' ### Get a grasp about the data structure
#' - View(): open another tab that shows the data
#' - glimpse(): returns number of rows and columns as well as some observations
#' - dim(): returns the dimension of the data
#' - summary(): summary about each variable
#' - names(): names of the variables
#' 
#' ### Pipe operator
?summarize()
?group_by()
cps %>% 
  group_by(black, female) %>% 
  summarize(employed = mean(employed, na.rm = TRUE))
# Equivalently,
summarize(group_by(cps, black, female),
          employed = mean(employed, na.rm = TRUE))
#' ### Dummy variable
table(cps$employed)
c(sample(c(0,1), 10, prob=c(0.5,0.5), replace=TRUE)) %>%
  print() %>%
  mean()
# The fraction of 1s in the entire observations, or in the sample
# The percentage of individuals in the sample who denoted as 1s.
mean(cps$employed, na.rm = TRUE)
cps %>% group_by(black) %>% summarize(mean(employed, na.rm=TRUE)) %>% 
  c(diff=.[[2,2]]-.[[1,2]]) 

#' ### t-stat
ggplot()+
  stat_function(fun=dt, args=list(df=8871), geom="line")+
  stat_function(fun=dt, args=list(df=8871), geom="area", fill="red", xlim=c(-5,-2)) +
  stat_function(fun=dt, args=list(df=8871), geom="area", fill="red", xlim=c(2,5)) +
  xlim(-10,10)+
  geom_vline(xintercept=-6.8, color="blue")+
  annotate("text", x= -6.8, y=-0.01,label="x=-6.8", color="blue")
