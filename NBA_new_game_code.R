library(readr)


nba_raw_data <- as.data.frame(read_csv("2018_2020_raw_data.csv"))

colnames(nba_raw_data)[1] <- 'Teams'

# 75% of the sample size
samp_size <- floor(0.75 * nrow(nba_raw_data))


## set the seed and split into training and test set
set.seed(007)
nba_train <- sample(seq_len(nrow(nba_raw_data)), size = samp_size, replace = TRUE)

train <- nba_raw_data[nba_train, ]
test <- nba_raw_data[-nba_train, ]


fit_model <- lm( `Difference-Points` ~ 0 + `Difference-Field Goal %` + `Difference-Three Point %` +
                     `Difference-Free Throw %` + `Difference-Rebounds` + `Difference-Offensive Rebounds` +
                     `Difference-Assists` + `Difference-Total Turnovers` + `Difference-FT attempts` + `Difference-3P attempts`,
                      data = nba_raw_data)

summary(fit_model)

nba_test <- as.data.frame(read_csv("2019_2020_fill_in.csv"))

nba_pred_test <- predict(fit_model, nba_test)

actual_pred_table <- data.frame(cbind('Teams' = nba_test$X1, 'Actual'= nba_test$`Difference-Points`,
                                       'Predicted' = nba_pred_test))

tail(actual_pred_table, 8)

# model retrain
# data leakage
