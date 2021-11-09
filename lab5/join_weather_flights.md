---
title: Join
output: 
   html_document:
      keep_md: true
---



```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.1.4     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(nycflights13)
```

## flights data


```r
head(flights, 10)
```

```
## # A tibble: 10 × 19
##     year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
##  1  2013     1     1      517            515         2      830            819
##  2  2013     1     1      533            529         4      850            830
##  3  2013     1     1      542            540         2      923            850
##  4  2013     1     1      544            545        -1     1004           1022
##  5  2013     1     1      554            600        -6      812            837
##  6  2013     1     1      554            558        -4      740            728
##  7  2013     1     1      555            600        -5      913            854
##  8  2013     1     1      557            600        -3      709            723
##  9  2013     1     1      557            600        -3      838            846
## 10  2013     1     1      558            600        -2      753            745
## # … with 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
## #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
## #   hour <dbl>, minute <dbl>, time_hour <dttm>
```

19 variables contained in flights data

## weather data


```r
head(weather, 10)
```

```
## # A tibble: 10 × 15
##    origin  year month   day  hour  temp  dewp humid wind_dir wind_speed
##    <chr>  <int> <int> <int> <int> <dbl> <dbl> <dbl>    <dbl>      <dbl>
##  1 EWR     2013     1     1     1  39.0  26.1  59.4      270      10.4 
##  2 EWR     2013     1     1     2  39.0  27.0  61.6      250       8.06
##  3 EWR     2013     1     1     3  39.0  28.0  64.4      240      11.5 
##  4 EWR     2013     1     1     4  39.9  28.0  62.2      250      12.7 
##  5 EWR     2013     1     1     5  39.0  28.0  64.4      260      12.7 
##  6 EWR     2013     1     1     6  37.9  28.0  67.2      240      11.5 
##  7 EWR     2013     1     1     7  39.0  28.0  64.4      240      15.0 
##  8 EWR     2013     1     1     8  39.9  28.0  62.2      250      10.4 
##  9 EWR     2013     1     1     9  39.9  28.0  62.2      260      15.0 
## 10 EWR     2013     1     1    10  41    28.0  59.6      260      13.8 
## # … with 5 more variables: wind_gust <dbl>, precip <dbl>, pressure <dbl>,
## #   visib <dbl>, time_hour <dttm>
```

15 variables contained in weather data


```r
table(weather$origin)
```

```
## 
##  EWR  JFK  LGA 
## 8703 8706 8706
```

We know that flights data has 19 variables and weather data has 15 variables. Notice that these two data have 6 overlapping variables, i.e. variables whose names are the same. Note that by default, when you use join() function, it will automatically match the two data by common variable names. Thus, in the newly joined data, we'll end up getting 28 variables, since 19+15-6.  

## Join
### Inner join


```r
inner = inner_join(flights, weather) 
```

```
## Joining, by = c("year", "month", "day", "origin", "hour", "time_hour")
```

```r
inner
```

```
## # A tibble: 335,220 × 28
##     year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
##  1  2013     1     1      517            515         2      830            819
##  2  2013     1     1      533            529         4      850            830
##  3  2013     1     1      542            540         2      923            850
##  4  2013     1     1      544            545        -1     1004           1022
##  5  2013     1     1      554            600        -6      812            837
##  6  2013     1     1      554            558        -4      740            728
##  7  2013     1     1      555            600        -5      913            854
##  8  2013     1     1      557            600        -3      709            723
##  9  2013     1     1      557            600        -3      838            846
## 10  2013     1     1      558            600        -2      753            745
## # … with 335,210 more rows, and 20 more variables: arr_delay <dbl>,
## #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
## #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>,
## #   temp <dbl>, dewp <dbl>, humid <dbl>, wind_dir <dbl>, wind_speed <dbl>,
## #   wind_gust <dbl>, precip <dbl>, pressure <dbl>, visib <dbl>
```

If you look closely the flights data, you notice that **there are multiple data points that share same year, same month, same day, same origin, same hour, same time_hour in flights data** while there's only one unique data point that share the same year, same month, same day, same origin, same hour, same time_hour in weather data. Therefore if you try to inner_join the two data, two data is combined such that multiple data points matched for each value combination of year, month, day, origin, hour, time_hour, resulting in the number of observations in the combined data to exceed the number of observation in the weather data. For example, as you could notice from below, there are 18 data points that correspond to 6 o'clock January 1, 2013,  whose flight origin is "EWR" in flights data. Therefore all 18 data points append to create the inner joined data. 



```r
flights %>% group_by(year, month, day, origin, hour, time_hour) %>% summarize(count=n())
```

```
## `summarise()` has grouped output by 'year', 'month', 'day', 'origin', 'hour'. You can override using the `.groups` argument.
```

```
## # A tibble: 19,486 × 7
## # Groups:   year, month, day, origin, hour [19,486]
##     year month   day origin  hour time_hour           count
##    <int> <int> <int> <chr>  <dbl> <dttm>              <int>
##  1  2013     1     1 EWR        5 2013-01-01 05:00:00     2
##  2  2013     1     1 EWR        6 2013-01-01 06:00:00    18
##  3  2013     1     1 EWR        7 2013-01-01 07:00:00    12
##  4  2013     1     1 EWR        8 2013-01-01 08:00:00    20
##  5  2013     1     1 EWR        9 2013-01-01 09:00:00    19
##  6  2013     1     1 EWR       10 2013-01-01 10:00:00    18
##  7  2013     1     1 EWR       11 2013-01-01 11:00:00    11
##  8  2013     1     1 EWR       12 2013-01-01 12:00:00    22
##  9  2013     1     1 EWR       13 2013-01-01 13:00:00    28
## 10  2013     1     1 EWR       14 2013-01-01 14:00:00    18
## # … with 19,476 more rows
```

### Left join


```r
left = left_join(flights, weather)
```

```
## Joining, by = c("year", "month", "day", "origin", "hour", "time_hour")
```

```r
left 
```

```
## # A tibble: 336,776 × 28
##     year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
##  1  2013     1     1      517            515         2      830            819
##  2  2013     1     1      533            529         4      850            830
##  3  2013     1     1      542            540         2      923            850
##  4  2013     1     1      544            545        -1     1004           1022
##  5  2013     1     1      554            600        -6      812            837
##  6  2013     1     1      554            558        -4      740            728
##  7  2013     1     1      555            600        -5      913            854
##  8  2013     1     1      557            600        -3      709            723
##  9  2013     1     1      557            600        -3      838            846
## 10  2013     1     1      558            600        -2      753            745
## # … with 336,766 more rows, and 20 more variables: arr_delay <dbl>,
## #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
## #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>,
## #   temp <dbl>, dewp <dbl>, humid <dbl>, wind_dir <dbl>, wind_speed <dbl>,
## #   wind_gust <dbl>, precip <dbl>, pressure <dbl>, visib <dbl>
```

If you `left_join(flights,weather)`, the number of observation of the merged data is exactly equal to the number of observation of flights data.

### Right join


```r
right = right_join(flights, weather)
```

```
## Joining, by = c("year", "month", "day", "origin", "hour", "time_hour")
```

```r
right
```

```
## # A tibble: 341,957 × 28
##     year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
##  1  2013     1     1      517            515         2      830            819
##  2  2013     1     1      533            529         4      850            830
##  3  2013     1     1      542            540         2      923            850
##  4  2013     1     1      544            545        -1     1004           1022
##  5  2013     1     1      554            600        -6      812            837
##  6  2013     1     1      554            558        -4      740            728
##  7  2013     1     1      555            600        -5      913            854
##  8  2013     1     1      557            600        -3      709            723
##  9  2013     1     1      557            600        -3      838            846
## 10  2013     1     1      558            600        -2      753            745
## # … with 341,947 more rows, and 20 more variables: arr_delay <dbl>,
## #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
## #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>,
## #   temp <dbl>, dewp <dbl>, humid <dbl>, wind_dir <dbl>, wind_speed <dbl>,
## #   wind_gust <dbl>, precip <dbl>, pressure <dbl>, visib <dbl>
```

If you `right_join(flights,weather)`, the number of observation of the merged data does **NOT** equal to the number of observation of weather data. Why? This is because, as mentioned earlier in `inner_join(flights,weather)` case, there are multiple data points that share the same year, month, day, origin, hour, and time_hour in flights data and thus, multiple data points are being matched to each value combination of origin and time_hour in weather data. 

### Conclusion
**Be aware of the structure of the combining data to see whether the merged data is the result of one-to-one or one-to-many or even many-to-many matching.** In the above case, it was one-to-many matching, where for each value combination in weather data is being matched to many observations in flights data. The in-lab example that we went over, however, was one-to-one matching, where for each value combination in `testd1` is matched to an unique combination in `testd2`.

 
   



---
author: boyoonc
date: '2021-11-08'

---
