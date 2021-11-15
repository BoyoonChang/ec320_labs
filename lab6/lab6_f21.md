---
title: "Lab 6 - Multiple Regression"
author: "Jenni Putz"
date: "11/12/2021"
output: 
  html_document:
    keep_md: TRUE
---



## Setup

```r
library(pacman)
p_load(tidyverse, stargazer, broom)

wages <- read_csv("wages.csv")
```

Let's look at the data frame:

```r
head(wages,10)
```

```
## # A tibble: 10 × 34
##       id nearc2 nearc4  educ   age fatheduc motheduc weight momdad14 sinmom14
##    <dbl>  <dbl>  <dbl> <dbl> <dbl>    <dbl>    <dbl>  <dbl>    <dbl>    <dbl>
##  1     3      0      0    12    27        8        8 380166        1        0
##  2     4      0      0    12    34       14       12 367470        1        0
##  3     5      1      1    11    27       11       12 380166        1        0
##  4     6      1      1    12    34        8        7 367470        1        0
##  5     7      1      1    12    26        9       12 380166        1        0
##  6     8      1      1    18    33       14       14 367470        1        0
##  7     9      1      1    14    29       14       14 496635        1        0
##  8    10      1      1    12    28       12       12 367772        1        0
##  9    11      1      1    12    29       12       12 480445        1        0
## 10    12      1      1     9    28       11       12 380166        1        0
## # … with 24 more variables: step14 <dbl>, reg661 <dbl>, reg662 <dbl>,
## #   reg663 <dbl>, reg664 <dbl>, reg665 <dbl>, reg666 <dbl>, reg667 <dbl>,
## #   reg668 <dbl>, reg669 <dbl>, south66 <dbl>, black <dbl>, smsa <dbl>,
## #   south <dbl>, smsa66 <dbl>, wage <dbl>, enroll <dbl>, KWW <dbl>, IQ <dbl>,
## #   married <dbl>, libcrd14 <dbl>, exper <dbl>, lwage <dbl>, expersq <dbl>
```

## Multiple Regression in R
We know how to do simple OLS--doing multiple OLS is just one easy step further! Let's run a regression of log wages on education and experience:

```r
reg1 <- lm(lwage ~ educ + exper, data = wages)
summary(reg1)
```

```
## 
## Call:
## lm(formula = lwage ~ educ + exper, data = wages)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.57440 -0.22238  0.02188  0.25802  1.17969 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 4.834500   0.092866   52.06   <2e-16 ***
## educ        0.080330   0.005259   15.27   <2e-16 ***
## exper       0.046395   0.003306   14.03   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.3877 on 1601 degrees of freedom
## Multiple R-squared:  0.1458,	Adjusted R-squared:  0.1447 
## F-statistic: 136.6 on 2 and 1601 DF,  p-value: < 2.2e-16
```
R gives us the t-stat and p-value so we can easily conduct hypothesis tests. Suppose we want to test 
$$H_0\text{: } \beta_1 = 0$$ vs $$H_1\text{: } \beta_1 \neq 0$$ at the 5% level.
We can look at the p-value and see that $p < \alpha$ so we can reject the null hypothesis at 5%.

Like last lab, we can use stargazer to summarize our regression results. This time, let's keep the adjusted $R^2$ in our table.

```r
stargazer(reg1, keep.stat = c("rsq", "adj.rsq", "n"), type = "text")
```

```
## 
## ========================================
##                  Dependent variable:    
##              ---------------------------
##                         lwage           
## ----------------------------------------
## educ                  0.080***          
##                        (0.005)          
##                                         
## exper                 0.046***          
##                        (0.003)          
##                                         
## Constant              4.835***          
##                        (0.093)          
##                                         
## ----------------------------------------
## Observations            1,604           
## R2                      0.146           
## Adjusted R2             0.145           
## ========================================
## Note:        *p<0.1; **p<0.05; ***p<0.01
```

### Confidence Intervals
How do we get confidence intervals in R? Let's do a 95% confidence interval.

Option 1: Construct by hand. We have the standard error and we have $\hat{\beta}_1$. We need to get the critical value of t.

```r
# We can use the qt() function to get the critical value of t. First put in your significance level. 
# for a two-tail test, make sure to divide by 2
# then the degrees of freedom. we have 1604-3 degrees of freedom
qt(.05/2, 1601)
```

```
## [1] -1.961447
```
The critical value of t is 1.96. Now we can plug that in to our confidence interval formula:
$$ .080330 - 1.96(.005259) \leq \beta_1 \leq .080330 + 1.96(.005259) $$
Which simplifies to:
$$ .0700 \leq \beta_1 \leq .0906$$

Option 2: Let R tell us. The `tidy()` function will give us the confidence interval if we tell it!

```r
tidy(reg1, conf.int = T)
```

```
## # A tibble: 3 × 7
##   term        estimate std.error statistic  p.value conf.low conf.high
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
## 1 (Intercept)   4.83     0.0929       52.1 0          4.65      5.02  
## 2 educ          0.0803   0.00526      15.3 2.86e-49   0.0700    0.0906
## 3 exper         0.0464   0.00331      14.0 2.80e-42   0.0399    0.0529
```
The confidence interval matches our by-hand solution! 

But this is for a 95%. How do we get `tidy()` to give us a different confidence level? What if we want a 90% confidence interval?

```r
tidy(reg1, conf.int = T, conf.level = .9)
```

```
## # A tibble: 3 × 7
##   term        estimate std.error statistic  p.value conf.low conf.high
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
## 1 (Intercept)   4.83     0.0929       52.1 0          4.68      4.99  
## 2 educ          0.0803   0.00526      15.3 2.86e-49   0.0717    0.0890
## 3 exper         0.0464   0.00331      14.0 2.80e-42   0.0410    0.0518
```


## Omitted Variable Bias

```r
reg1 <- lm(lwage ~ educ, data = wages)
reg2 <- lm(lwage ~ educ + exper, data = wages)
stargazer(reg1, reg2, keep.stat = c("rsq", "adj.rsq", "n"), type = "text")
```

```
## 
## =========================================
##                  Dependent variable:     
##              ----------------------------
##                         lwage            
##                   (1)            (2)     
## -----------------------------------------
## educ            0.037***      0.080***   
##                 (0.005)        (0.005)   
##                                          
## exper                         0.046***   
##                                (0.003)   
##                                          
## Constant        5.816***      4.835***   
##                 (0.065)        (0.093)   
##                                          
## -----------------------------------------
## Observations     1,604          1,604    
## R2               0.041          0.146    
## Adjusted R2      0.040          0.145    
## =========================================
## Note:         *p<0.1; **p<0.05; ***p<0.01
```

What is the sign of the OVB? Use the formula:
$$ Bias = \beta_2 \frac{cov(X_1, X_2)}{var(X_1)} $$
$\beta_2 = .046$, which is positive. We can get the covariance by using the covariance function.

```r
cov(wages$educ, wages$exper)
```

```
## [1] -4.759561
```
There is a negative bias from omitting experience.

Let's do another regression.

```r
reg3 <- lm(lwage ~ educ + exper + IQ, data = wages) # positive bias from omitting IQ (imperfect proxy for intelligence)
stargazer(reg1, reg2, reg3, keep.stat = c("rsq", "adj.rsq", "n"), type = "text")
```

```
## 
## ==========================================
##                   Dependent variable:     
##              -----------------------------
##                          lwage            
##                 (1)       (2)       (3)   
## ------------------------------------------
## educ         0.037***  0.080***  0.069*** 
##               (0.005)   (0.005)   (0.006) 
##                                           
## exper                  0.046***  0.048*** 
##                         (0.003)   (0.003) 
##                                           
## IQ                               0.004*** 
##                                   (0.001) 
##                                           
## Constant     5.816***  4.835***  4.587*** 
##               (0.065)   (0.093)   (0.104) 
##                                           
## ------------------------------------------
## Observations   1,604     1,604     1,604  
## R2             0.041     0.146     0.159  
## Adjusted R2    0.040     0.145     0.158  
## ==========================================
## Note:          *p<0.1; **p<0.05; ***p<0.01
```
How are IQ and education correlated? Check the OVB formula again.
Here, $\beta_3 = .004$ which is positive. We can check the covariance to get the sign of the bias:

```r
cov(wages$educ, wages$IQ)
```

```
## [1] 16.96962
```
IQ and education are positively correlated and there is a positive bias from omitting IQ.

We can keep adding variables to our regression:

```r
reg4 <- lm(lwage ~ educ + exper + IQ + KWW, data = wages) 
reg5 <- lm(lwage ~ educ + exper + IQ + KWW + fatheduc, data = wages) 
reg6 <- lm(lwage ~ educ + exper + IQ + KWW + fatheduc + motheduc, data = wages) 
stargazer(reg1, reg2, reg3, reg4, reg5, reg6, keep.stat = c("rsq", "adj.rsq", "n"), type = "text")
```

```
## 
## ==================================================================
##                               Dependent variable:                 
##              -----------------------------------------------------
##                                      lwage                        
##                (1)      (2)      (3)      (4)      (5)      (6)   
## ------------------------------------------------------------------
## educ         0.037*** 0.080*** 0.069*** 0.058*** 0.058*** 0.057***
##              (0.005)  (0.005)  (0.006)  (0.006)  (0.006)  (0.006) 
##                                                                   
## exper                 0.046*** 0.048*** 0.041*** 0.042*** 0.042***
##                       (0.003)  (0.003)  (0.004)  (0.004)  (0.004) 
##                                                                   
## IQ                             0.004*** 0.003*** 0.003*** 0.003***
##                                (0.001)  (0.001)  (0.001)  (0.001) 
##                                                                   
## KWW                                     0.006*** 0.006*** 0.006***
##                                         (0.002)  (0.002)  (0.002) 
##                                                                   
## fatheduc                                          0.003   -0.0003 
##                                                  (0.003)  (0.004) 
##                                                                   
## motheduc                                                   0.008* 
##                                                           (0.004) 
##                                                                   
## Constant     5.816*** 4.835*** 4.587*** 4.672*** 4.664*** 4.634***
##              (0.065)  (0.093)  (0.104)  (0.106)  (0.106)  (0.108) 
##                                                                   
## ------------------------------------------------------------------
## Observations  1,604    1,604    1,604    1,604    1,604    1,604  
## R2            0.041    0.146    0.159    0.167    0.168    0.170  
## Adjusted R2   0.040    0.145    0.158    0.165    0.165    0.167  
## ==================================================================
## Note:                                  *p<0.1; **p<0.05; ***p<0.01
```

Let's look a little closer at the models with father's education included. The coefficient is not statistically significant. Should we still include this variable in our regression?

**YES**
Remember, if we exclude variables that should be in the
model and they are correlated with the regressors that we
include, then we will have
omitted variable bias
-- Even if they aren’t correlated with the included variables, they
help us tighten up our standard errors
-- If theory or intuition says you should have a variable in the
model, then it should be in there!


## F-tests
Let's suppose we want to test to see if the coefficients on father's education and mother's education are equal to zero at the 5% level.
The null hypothesis is:
$$H_0\text{: } \beta_5 = \beta_6 = 0$$
The alternative hypothesis is:
$$H_1\text{: either } \beta_5 \neq 0 \text{ or } \beta_6 \neq 0$$

To do the test, we need to identify our *restricted* model and our *unrestricted* model. `reg4` is the restricted model and `reg6` is the unrestricted. 

Recall, the F-stat is equal to:
$$F = \frac{(R^2_u - R^2_r)/q}{(1-R^2_u)/(n-k-1)}$$

The easy way and have R do it for us: Load the `car` package to use this function:

```r
p_load(car)
linearHypothesis(reg6, c("fatheduc=0", "motheduc=0"))
```

```
## Linear hypothesis test
## 
## Hypothesis:
## fatheduc = 0
## motheduc = 0
## 
## Model 1: restricted model
## Model 2: lwage ~ educ + exper + IQ + KWW + fatheduc + motheduc
## 
##   Res.Df    RSS Df Sum of Sq      F Pr(>F)
## 1   1599 234.57                           
## 2   1597 233.93  2   0.64137 2.1892 0.1123
```

