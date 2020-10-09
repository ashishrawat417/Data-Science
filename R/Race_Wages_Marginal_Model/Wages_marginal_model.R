  ### Add packages we use in Assignment 3
library("plyr")
library("tidyverse")
library("nlme")
library("car")
library("hexbin")
library("xtable")
library("knitr")
library("multcomp")
library("lmerTest")

HourlyWage <- read.csv(file = 'WageRace.csv')
View(HourlyWage)

###################################################################################################################################################################################

### 1. Graphical analysis
# Table 1: Summary of HW grouped by Year and Race.

# MAKING VARIABLE DISCRTE WITH FACTOR
HourlyWage <- mutate(HourlyWage, Subject.f = factor(Subject), Race.f = factor(Race), Year.f = factor(Year))
Table_1 <- ddply(HourlyWage, c("Race", "Year.f"), summarise, n = length(HW), HW_mean = mean(HW), HW_stdev = sd(HW))
view(Table_1)

# Figure 1: Plot of mean HW vs Year grouped by Race
ggplot(data = Table_1, aes(x = Year.f, y = HW_mean)) +
  geom_point(aes(colour = Race), size = 4, shape = 15) +
  scale_x_discrete("Year") +
  scale_y_continuous(limits = c(5.0, 7.5), breaks=seq(5.0, 7.5, 0.5))


#Figure 2: Scatter plot of HW vs Y ear grouped by Race
ggplot(data = HourlyWage, aes(x = Year.f, y = HW)) +
  geom_point(colour = "black") +
  scale_x_discrete("Year") +
  ylim(0, 25) + 
  facet_grid(.~ Race.f) +
  theme(legend.position="none")

HourlyWage <- mutate(HourlyWage, 
                      Index = if_else(
                          Year == 1984, 1, 
                            if_else(Year == 1985, 2, 
                                    if_else(Year == 1986, 3, 
                                            if_else(Year == 1987, 4, 5)))))

####################################################################################################################################################################

#### 3. Choosing the appropriate R matrix
## Fitting model 1 using gls() and REML

Model1A <- gls(
  HW ~ Y2 + Y3 + Y4 + H + Y2:H + Y3:H + Y4:H, 
  correlation = corSymm(form = ~ Index| Subject), 
  method = "REML", 
  data = HourlyWage
)
#summary(Model1A)

# Estimte of the R matrix in model 1
R_hat_1A <- getVarCov(Model1A, type= "conditional") # The R matrix is the same as the variance-covariance matrix of the response vector
R_hat_1A

# Converting the R_hat data frame to a latex array environment and saving it the latex file "Model1_var_covar.tex".
#print(xtableMatharray(R_hat_1A, digits = 3, align = "ccccc"), file = "Model1_var_covar.tex", append = TRUE)


## Using AIC and BIC to compare models with different R-matrices. 
Model1B <- gls(
  HW ~ Y2 + Y3 + Y4 + H + Y2:H + Y3:H + Y4:H, 
  correlation = corAR1(form = ~ Index| Subject), 
  method = "REML", 
  data = HourlyWage
)
#summary(Model1B)

# Estimte of the R matrix in model 1
R_hat_1B <- getVarCov(Model1B, type= "conditional") # The R matrix is the same as the variance-covariance matrix of the response vector
R_hat_1B

Model1C <- gls(
  HW ~ Y2 + Y3 + Y4 + H + Y2:H + Y3:H + Y4:H, 
  correlation = corCompSymm(form = ~ Index| Subject), 
  method = "REML", 
  data = HourlyWage
)
#summary(Model1C)

# Estimte of the R matrix in model 1
R_hat_1C <- getVarCov(Model1C, type= "conditional") # The R matrix is the same as the variance-covariance matrix of the response vector
R_hat_1C

AIC(Model1A, Model1B, Model1C) # By default k = 2

BIC <- AIC(Model1A, Model1B, Model1C, k = log(592)) # There are a total of N = 592 observations used to fit the marginal models
BIC

#anova(Model1A, Model1B, Model1C)

##########################################################################################################################################################

#### 4. Fixed effect estimates for your final marginal model

# ## Table 7: The estimates of the fixed effects in model 1.
Table_fixd_eff <-summary(Model1A)$tTable
Table_fixd_eff


### 11. Estimating the contrast t = -beta5 + beta6 and testing the null hypothesis tau = 0.
C <- matrix(c(0, 0, 0, 0, 0, -1, 1, 0), 1)
beta6_5_Contrast <- glht(Model1A, linfct = C)
summary(beta6_5_Contrast)


### 13. Estimating the contrast t = -beta5 + beta6 and testing the null hypothesis tau = 0.
C <- matrix(c(0, 0, 0, 0, 0, -1, 0, 1), 1)
beta7_5_Contrast <- glht(Model1A, linfct = C)
summary(beta7_5_Contrast)

