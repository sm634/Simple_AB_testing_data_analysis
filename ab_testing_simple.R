library(aod)
library(ggplot2)

ab_data = read.csv("cleaned_ab_data.csv")
head(ab_data)

## We now want to use the glm() function to estimate a logistic regression model. 
## But first, we will convert the 'group' column/variable into a categorical variable.

ab_data$group = factor(ab_data$group)
logitmodel = glm(converted ~ group, data = ab_data, family = "binomial")

summary(logitmodel) 

