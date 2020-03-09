# Developing the model from a train set before testing it on an unseen data set. Proving all assumptions with graphical proof 

library(readr)
library(car)
#############################################################################################
nba_raw_data <- as.data.frame(read_csv("2019_2020_raw_data.csv"))

colnames(nba_raw_data)[1] <- 'Teams'

# 75% of the sample size
samp_size <- floor(0.75 * nrow(nba_raw_data))

## set the seed and split into training and test set
set.seed(007)
nba_train <- sample(seq_len(nrow(nba_raw_data)), size = samp_size, replace = TRUE)

train <- nba_raw_data[nba_train, ]
test <- nba_raw_data[-nba_train, ]

# Build model

model_train <- lm( `Difference-Points` ~ 0 + `Difference-Field Goal %` + `Difference-Three Point %` +
                  `Difference-Free Throw %` + `Difference-Rebounds` +
                  `Difference-Defensive Rebounds` + `Difference-Assists` + `Difference-Total Turnovers` + 
                  `Difference-FG attempts` + `Difference-3P attempts` + `Difference-FT attempts`, data = train)

summary(model_train)
#############################################################################################
nba_raw_data2 <- as.data.frame(read_csv("2018_2020_raw_data.csv"))

colnames(nba_raw_data2)[1] <- 'Teams'

# 75% of the sample size
samp_size <- floor(0.75 * nrow(nba_raw_data2))

## set the seed and split into training and test set
set.seed(007)
nba_train2 <- sample(seq_len(nrow(nba_raw_data2)), size = samp_size, replace = TRUE)

train2 <- nba_raw_data2[nba_train2, ]
test2 <- nba_raw_data2[-nba_train2, ]

# Build model

model_train2 <- lm( `Difference-Points` ~ 0 + `Difference-Field Goal %` + `Difference-Three Point %` +
                     `Difference-Free Throw %` + `Difference-Rebounds` +
                     `Difference-Defensive Rebounds` + `Difference-Assists` + `Difference-Total Turnovers` + 
                     `Difference-FG attempts` + `Difference-3P attempts` + `Difference-FT attempts`, data = train2)

summary(model_train2)

################################################################################################

variance_of_inflation <- vif(model_train)
residuals_nba <- resid(model_train)

# Residual plot versus fitted values
resid_plot <- plot(train$`Difference-Points`, residuals_nba, ylab = 'Standardized Residuals', xlab = 'Fitted values',
                   main = 'Versus Fit')
abline(0,0)

# QQ-normality plot
normailty_plot <- qqnorm(residuals_nba, ylab = 'Standardized Residuals', xlab = 'Normal Score')
qqline(residuals_nba)

# Hisogram of residuals
histogram_residuals <- hist(residuals_nba, ylab = 'Standardized Residuals', xlab = 'Frequency' )

# Versus Order plot
order_plot <- plot(residuals_nba, pch=20, ylab = 'Standardized Residuals', xlab = 'Order', cex.main = 0.95)

# Using the model to predict test set
nba_pred <- predict(model_train, test)

actual_pred <- data.frame(cbind('Teams' = test$Teams, 'Actual'= test$`Difference-Points`, 'Predicted' = nba_pred))
correlation_accuracy <- cor(actual_pred)
head(actual_pred, 20)





