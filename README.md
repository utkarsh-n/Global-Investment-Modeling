# Global-Investment-Modeling

#### Introduction:
&nbsp; 
<p>
&nbsp; In this project, we will replicate and diagnose the findings of Appel and Loyle from their study on post-conflict justice and foreign direct investment. In the article titled*The economic benefits of justice: post-conflict justice (PCJ) and foreign direct investment (FDI)* the authors seek to explain if post-conflict states that implement post-conflict justice are more likely to receive foreign direct investments than those states which refrain from implementing justice institutions.
</p>
<p>
&nbsp; I selected this article to examine more closely if the credibility commitments that certain states hold up are actually genuine, or if there is a factor that makes them more likely than another state to implement justice institutions. 
</p>
&nbsp; 

#### Replication:
&nbsp; 
<p>
&nbsp; The authors argue that PCJs are in two categories: restorative and retributive. Restorative justice is the primary focus for this paper, as they serve as signals of stability. Since a PCJ is a costly signal both politically and financially, there is likely a high chance that the actors are acting in good faith. This Forms the basis of Appel and Loyle’s Hypothesis Ho: FDI is likely to be greater in a post-conflict state where there is a PCJ compared with a post- conflict state that lacks a similar justice institution. 
</p>
<p>
&nbsp; The population model, as stated by the authors, comes from the  Post-Conflict Justice dataset, focusing on PCJ activity related to all extra systemic, internationalized internal and internal armed conflicts with at least 25 annual battle-related deaths as coded by the UCDP/PRIO Armed Conflict Database. Only internal armed conflicts, including internationalized conflicts, in developing nations from 1970 to 2001 are of focus. After combining same-state conflicts, the results is a dataset with 95 civil conflicts.
</p>
<p>
&nbsp; For this project’s sample model, which will be the Final EQ, the authors tested effects of three control variables: Economic, Institutions, and Conflict. The indepdendent variables are measured as PCJ (No to Yes), Economic size (25th to 75th percentile),  Economic growth (25th to 75th percentile), KAOPEN Index (25th to 75th percentile), Exchange rate (25th to 75th percentile), Damage, Political constraints (25th to 75th percentile), Regime type (+/- 8). 
</p>


<p>
&nbsp; In their study, the authors measured their control variables based on their relation to economic controls, politicla institiutions, and conflict from their PCJ dataset published in 2012. 
/p>

#### The authors model on the Final EQ is replicated below:

```{r, echo= FALSE, message=FALSE}
# replicate ApplelLoyle data

# load package and import data
library(haven)
appelloyle_jprdata <- read_dta("Appel and Loyle Rep Data/appelloyle_jprdata.dta")
View(appelloyle_jprdata)

appelloyle_jprdata <- as.data.frame(appelloyle_jprdata)
# estimate model
model1 <- lm(v3Mdiff ~ truthvictim + fv8 + fv10 + fv11 + fv34 + fv27 + victory_lag + cw_duration_lag + damage + peace_agreement_lag + coldwar + polity2 + xratf + labor + v64mean, data = appelloyle_jprdata)

# report model in table
library(stargazer)

# stargazer
stargazer(appelloyle_jprdata, type="text", title="Summary Statistics")

class(appelloyle_jprdata)

stargazer(model1, type="text")
```

#### Standard error test

```{r,  echo=FALSE}
# load packages
library(car)
library(lmtest)
library(sandwich)
library(zoo)
 # White robust standard errors
model1.r<-coeftest(model1,vcov=vcovHC(model1,type="HC1"))
model1.r
```


<p>
&nbsp; With the results fully and accurately replicated for the Final EQ, we can see that they in fact do match the observations shown in Table 1 of Appel and Loyle's article. THe PCJ is shown to be a statistically significant variable even after controls were ensured, making them fail to reject their hypothesis. The significant variables at one level are fv8 (economic development, fv10 (Economic Size), and peace_agreement_lag (Peace Agreement).The author includes corrections to account for robustness by including two human rights variables: Physical Integrity Rights and Workers’ Rights from the Cingranelli- Richards (CIRI) Human Rights Dataset (Cingranelli & Richards, 2010). We will test to see if these variables made an impact in a diagnostic test.
</p>

#### Diagnostic Tests and Corrections
&nbsp;

<p>
&nbsp;In order to satisfy the Gauss-Markov Theorem, the model must be diagnosed to meet certain criteria. If the Gauss-Markov theorem is satisfied, we know we have the best fitted model. In order to test this, we run test to determine heteroskedacity, OLS estimates, multicollinearity and variance tests, and calculating Cooks' D threshold. </p>

<p>
&nbsp; We can start off by plotting residuals against fitted values to determine independence and linearity.
</p>

#### Fitted vs Residual Plot
&nbsp;
<p>
&nbsp; The contents of the loess curve indicate that the fitted and residual points follow the same line minus some outliers. We can at least confirm that there is no evidence of heteroskedsticity.
</p> A RESET test will be able to tell us if there is any non-linearity for certain in residuals.

```{r, echo= FALSE}
model1 <- lm(v3Mdiff ~ truthvictim + fv8 + fv10 + fv11 + fv34 + fv27 + victory_lag + cw_duration_lag + damage + peace_agreement_lag + coldwar + polity2 + xratf + labor + v64mean, data = appelloyle_jprdata)
library(broom)
appel.v2 <- augment_columns(model1, appelloyle_jprdata)
library(ggplot2)
ggplot(appel.v2, aes(x=.fitted, y=.resid)) + geom_hline(yintercept=0) +
geom_point() + geom_smooth(method='loess', se=TRUE)
```


#### Robust Model
&nbsp;
<p>
&nbsp; When testing the robust model that takes the two control variables into account, the relationshio between fitted and residual lines appears visually stronger.
</p>


```{r, echo= FALSE}
model2 <- lm(v2diff ~ truthvictim + fv8 + fv10 + fv11 + fv34 + fv27 + victory_lag + cw_duration_lag + damage + peace_agreement_lag + coldwar + polity2 + xratf + labor + v64mean, data = appelloyle_jprdata)
library(broom)
appel.v3 <- augment_columns(model2, appelloyle_jprdata)
library(ggplot2)
ggplot(appel.v3, aes(x=.fitted, y=.resid)) + geom_hline(yintercept=0) +
geom_point() + geom_smooth(method='loess', se=TRUE)

```

#### OLS Estimates
&nbsp;
<p>
&nbsp; After a RESET test, edivence shows that the F-statistic is 144.24 and p is 2.2e-16, or -10.02. Given this, we fail to reject the null hypothesis as there is no difference in how the model changes/
</p>

```{r, echo= FALSE}
# OLS estimates for final model 1
library(broom)
appel.v2 <- augment_columns(model1, appelloyle_jprdata)
appel.q <- lm(v3Mdiff ~ truthvictim + fv8 + fv10 + fv11 + fv34 + fv27 + victory_lag + cw_duration_lag + damage + peace_agreement_lag + coldwar + polity2 + xratf + labor + v64mean + I(.fitted^2), data = appel.v2)
 # F test of model difference
anova(model1, appel.q)
```



#### Multicollinearity Test
&nbsp;
<p>
&nbsp; By running a test of multicollinearity we can see if the variables have a high vairance inflation factor, which they do not appear to.
</p>

```{r, echo= FALSE}
# multicollinearity
library(car) 
vif(model1)
```


#### Cook/Weisberg Error Variance
&nbsp;
<p>
&nbsp; In order to satisfy the Gauss-Markov theorem by maintaining constant error significance accross all obbsrvations, we can test error variance using two tests.
</p>


```{r, echo= FALSE}

#test heteroskedasticity
# Cook/Weisberg score test of constant error variance 
library(car)
ncvTest(model1)
```

#### Breush/Pagan Error Variance
&nbsp;
<p>
&nbsp; Both Cook/Wiesberg and Breush/Bagan's tests show a low p-value, indicative of violation of the White robust error standard. 

</p>


```{r, echo= FALSE}
# Breush/Pagan test of constant error variance
library(lmtest) 
bptest(model1)
```

#### Diagnosing Influential Observations
&nbsp;
<p>
&nbsp; We can diagnose influential observations to see if the coefficient estimates change, using Cook's distance plot.
</p>

```{r, echo= FALSE}
#(diagnose influential observations
# create observation id
appel.v2$id <- as.numeric(row.names(appel.v2))
 # identify obs with Cook's D above cutoff
ggplot(appel.v2, aes(id, .cooksd)) + geom_bar(stat="identity", position="identity") + xlab("Obs. Number")+ylab("Cook's distance")+ geom_hline(yintercept=0.014) + geom_text(aes(label=ifelse((.cooksd>0.0645),id,"")), vjust=-0.2, hjust=0.5)
```



#### Observations above Cook's D threshold
&nbsp;
<p>
&nbsp; The plot indicates there are eight observations above the threshold of .0645. We now test the model without these to see if the results change. 
</p>


```{r, echo= FALSE}
# list observations whose Cook's D above threshold
appel.v2[appel.v2$.cooksd>0.0645, c('id',"ccode",'.fitted',".std.resid",".hat",".cooksd")]

```


#### Re-Estimating the Model
&nbsp;
<p>
&nbsp; The outputs show  similar values, meaning the residuals have stayed the same despite removing the values above Cook's D threshold.
</p>

```{r, echo= FALSE}
 # re-estimate model without influential obs
model1.no <- lm(v3Mdiff ~ truthvictim + fv8 + fv10 + fv11 + fv34 + fv27 + victory_lag + cw_duration_lag + damage + peace_agreement_lag + coldwar + polity2 + xratf + labor + v64mean, data=appel.v2[appel.v2$.cooksd<0.0645,])

# estimation results without outliers
summary(model1.no)
```

#### Normality Diagnostics
&nbsp;
<p>
&nbsp; Once plotted, the plot without the values shows that the amount of high redisuals in high quantiles decreased, bringing the distribution in a smaller range. The Asymptotes are violated in the graphs, indicative that the model without the outliers is a better OLS estimate.
</p>


```{r, echo= FALSE}
# Normality diagnostics
library(car) 
qqPlot(model1,distribution="t",simulate=TRUE,grid=TRUE) 
qqPlot(model1.no,distribution="t",simulate=TRUE,
grid=TRUE)
```

#### Normality Test
&nbsp;
<p>
&nbsp; A normality trest supplements the findings that the first model does not have normality, but the second one seems to have a strong p-value of .001.
</p>

```{r, echo= FALSE}
 #normality test
shapiro.test(residuals(model1))
```

```{r, echo= FALSE}
shapiro.test(residuals(model1.no))
```

#### Results
&nbsp;
<p>
&nbsp; Before reaching a conclusion, we can compare our standard model, model of robustness, model and without outliers. We can see that the original model bears great weight on the significance of exhange rate functions and economic size, while the model without outliers bears great weight on the KAOPEN index, Peace agreements, and truthvictim, which all 3 models show a level of signigicance.
</p>


```{r, echo= FALSE}
#report results in table
library(stargazer)
stargazer(model1, model1.r, model1.no, type="text",
no.space=TRUE, omit.stat=c("f","ser"),model.names=FALSE, dep.var.labels.include=FALSE, dep.var.caption="")
```

#### Conclusion
&nbsp;
<p>
&nbsp; When setting out to accomplish this project, I was hoping that I would find results close to the original findings. That would indicate to me that both the article and my work were done right. I believe I achieved that task, as the data from my replication closely matches that of the work of Appel and Loyle. I found that despite being unable to reject the hypothesis, there are several variables that can improperly give the illusion of a statistical relationship. Especially when modifying the outliers, which resulted in a much more accurate OLS estimate. I did expect the Gauss-Markov theorem to be met, but I understand the reasons as to why it could not happen, as the variance was inconsistent. While I only solved the final model, and not all four, I found my conculsions were similar to the authors, who overall agreed that there is a benefit for countries seeking FDI if they allow PCJ. It is evident by the residuals that economy, size, and signigicance of the country certainly play underlying roles in this.

#### References

&nbsp; Appel, B. J., & Loyle, C. E. (2012). The economic benefits of justice: Post-conflict justice and foreign direct investment. Journal of Peace Research, 49(5), 685-699.


