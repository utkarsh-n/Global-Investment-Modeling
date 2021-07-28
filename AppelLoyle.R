# replicate ApplelLoyle data

# load package and import data
library(haven)
appelloyle_jprdata <- read_dta("Appel and Loyle Rep Data/appelloyle_jprdata.dta")
View(appelloyle_jprdata)

appelloyle_jprdata <- as.data.frame(appelloyle_jprdata)
# estimate model
model1 <- lm(v3Mdiff ~ truthvictim + fv8 + fv10 + fv11 + fv34 + fv27 + victory_lag + cw_duration_lag + damage + peace_agreement_lag + coldwar + polity2 + xratf + labor + v64mean, data = appelloyle_jprdata)

summary(model1)

# report model in table
library(stargazer)

# stargazer
stargazer(appelloyle_jprdata, type="text")

class(appelloyle_jprdata)

stargazer(model1, type="text")

