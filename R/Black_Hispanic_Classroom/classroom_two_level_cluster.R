### Add packages you use in Assignment 2
library("plyr")
library("tidyverse")
library("nlme")
library("car")
library("hexbin")
library("xtable")
library("multcomp")
library("lmerTest")

############################################################################################################################################################

## Importing the ClassRoom data file from my computer.
ClassRoom <- read.csv(file = 'Classroom.csv')
view(ClassRoom)

#ClassRoom_12 <-filter(ClassRoom, Classid == 145)

ClassRoom <- mutate(
    ClassRoom, 
    Classid.f = factor(Classid), 
    Childid.f = factor(Childid), 
    YE.f = factor(YE),
)

#View(unique(ClassRoom$Classid))
View(ClassRoom)


#### 2. Testing for the random intercept
Model1 <- lme(
  MG ~ YE + MK + HP + YE:MK + YE:HP + MK:HP, 
  random = ~ 1 | Classid.f, 
  method = "REML", 
  data = ClassRoom
)
summary(Model1)

#GLS MODEL WITHOUT INTERCEPT
Model2 <- gls(
  MG ~ YE + MK + HP + YE:MK + YE:HP + MK:HP, 
  method = "REML", 
  data = ClassRoom
)
summary(Model2)

anova(Model1, Model2) # Obtain ln(LRR) and ln(LNR)
LRT <- anova(Model1, Model2)$L.Ratio[-1] # Obtain LRT = 2ln(LRR) - 2ln(LNR)

# Calculating the p-value for the REML based likelihood ratio test
p_value <- (0.5 * pchisq(LRT, df = 0, lower.tail = FALSE)) + (0.5 * pchisq(LRT, df = 1, lower.tail = FALSE))
p_value #6.880054e-10


############################################################################################################################################################

#### 3. Variance-covariance estimates of the final linear mixed model

## The estimate of the D matrix in model 3.
D_hat <- getVarCov(Model1)[-3,] # Gives the D matrix
D_hat


## ESTIMATE OF R3 MATRIX OF FULL LINEAR MODEL in model1 for class3
R_hat_3 <- getVarCov(Model1, individual = 3, type = "conditional")[[1]] 
R_hat_3

print(xtableMatharray(R_hat_3, digits = 3, align = "ccccc"), file = "R_hat_3.tex")


## Estimte of the Var(Y) in model 1 for Class 3.
VarY_hat3 <- getVarCov(Model1, individual = 3, type = "marginal")[[1]] 
VarY_hat3
print(xtableMatharray(VarY_hat3, digits = 3, align = "ccccc"), file = "VarY_hat3.tex")


## Table 6: The estimates and approximate 95% confidence inetervals for sigma_mu0_square.
Table_sigma_mu <- intervals(Model1)$reStruct[[1]]
Table_sigma_mu


# ## Table 7: The estimates of the fixed effects in model 1.
Table_fixd_eff <-summary(Model1)$tTable
Table_fixd_eff
print(xtableMatharray(Table_fixd_eff, digits = 3, align = "cccccc"), file = "Table_fixd_eff.tex")


#TO FIND INTERCEPTS of model1 
Table_1 <- round(ranef(Model1), 4)
View(Table_1)

######################################################################################################################################################
#### 4. Predicted values and residuals of the final linear mixed model

# Generating the predicted marginal values of MG
ClassRoom <- mutate(ClassRoom, Marg_MG_hat = fitted(Model1, level = 0))

# Generating the predicted conditional values of MG.
ClassRoom <- mutate(ClassRoom, Cond_MG_hat = fitted(Model1, level = 1))

# Obtaining conditional residuals
ClassRoom <-  mutate(ClassRoom, Cond_Resid = MG - Cond_MG_hat)
View(ClassRoom)
