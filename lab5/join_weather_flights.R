#' ---
#' title: Join
#' output: 
#'    html_document:
#'       keep_md: true
#' ---
#' 


library(tidyverse)
library(nycflights13)

#' ## flights data
head(flights, 10)
#' 19 variables contained in flights data
#' 
#' ## weather data
head(weather, 10)
#' 15 variables contained in weather data
table(weather$origin)
#' We know that flights data has 19 variables and weather data has 15 variables. Notice that these two data have 6 overlapping variables, i.e. variables whose names are the same. Note that by default, when you use join() function, it will automatically match the two data by common variable names. Thus, in the newly joined data, we'll end up getting 28 variables, since 19+15-6.  

#' 
#' ## Join
#' ### Inner join
inner = inner_join(flights, weather) 
inner
#' If you look closely the flights data, you notice that **there are multiple data points that share same year, same month, same day, same origin, same hour, same time_hour in flights data** while there's only one unique data point that share the same year, same month, same day, same origin, same hour, same time_hour in weather data. Therefore if you try to inner_join the two data, two data is combined such that multiple data points matched for each value combination of year, month, day, origin, hour, time_hour, resulting in the number of observations in the combined data to exceed the number of observation in the weather data. For example, as you could notice from below, there are 18 data points that correspond to 6 o'clock January 1, 2013,  whose flight origin is "EWR" in flights data. Therefore all 18 data points append to create the inner joined data. 
#' 
flights %>% group_by(year, month, day, origin, hour, time_hour) %>% summarize(count=n())

#' ### Left join
left = left_join(flights, weather)
left 
#' If you `left_join(flights,weather)`, the number of observation of the merged data is exactly equal to the number of observation of flights data.
#' 
#' ### Right join
right = right_join(flights, weather)
right
#' If you `right_join(flights,weather)`, the number of observation of the merged data does **NOT** equal to the number of observation of weather data. Why? This is because, as mentioned earlier in `inner_join(flights,weather)` case, there are multiple data points that share the same year, month, day, origin, hour, and time_hour in flights data and thus, multiple data points are being matched to each value combination of origin and time_hour in weather data. 
#' 
#' ### Conclusion
#' **Be aware of the structure of the combining data to see whether the merged data is the result of one-to-one or one-to-many or even many-to-many matching.** In the above case, it was one-to-many matching, where for each value combination in weather data is being matched to many observations in flights data. The in-lab example that we went over, however, was one-to-one matching, where for each value combination in `testd1` is matched to an unique combination in `testd2`.
#' 
#'  
#'    
#' 