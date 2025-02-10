# Load necessary libraries
install.packages("tidyverse")  # Install all necessary packages at once
library(ggplot2)
library(dplyr)

# ----------------------------- #
# ??????? 1. Data Preprocessing
# ----------------------------- #

# Read dataset
data <- read.csv("D:/Analytics/vehicle-sales-analysis/Data/Raw/dataset.csv")

# Remove missing values
clean_data <- na.omit(data)

# Drop unnecessary columns
columns_to_remove <- c("s?ledate", "body", "state", "seller", "trim", "make", "model", "vin")
data_final <- clean_data %>%
  select(-one_of(columns_to_remove))

# Convert categorical variables to factors
categorical_vars <- c("interior", "color", "transmission")
data_final[categori?al_vars] <- lapply(data_final[categorical_vars], as.factor)

# Ensure directory exists before saving
dir.create("D:/Analytics/vehicle-sales-analysis/Data/Processed", recursive = TRUE, showWarnings = FALSE)

# Save cleaned dataset
write.csv(data_final, "D:/?nalytics/vehicle-sales-analysis/Data/Processed/Cleaned_Dataset.csv", row.names = FALSE)

print("??? Data Preprocessing Completed!")

# ----------------------------- #
# ???? 2. Exploratory Data Analysis (EDA)
# ----------------------------- #

# Load cleaned data
data_final <- read.csv("D:/Analytics/vehicle-sales-analysis/Data/Processed/Cleaned_Dataset.csv")

# Summary statistics
summary(data_final)

# Histogram of Selling Pr?ce
ggplot(data_final, aes(x = sellingprice)) +
  geom_histogram(binwidth = 1000, fill = "blue", color = "black") +
  labs(title = "Distribution of Selling Prices", x = "Selling Price", y = "Frequency")

# Scatter plot of MMR vs Selling Price
ggplot(data_fi?al, aes(x = mmr, y = sellingprice)) +
  geom_point(alpha = 0.5, color = "red") +
  labs(title = "MMR Value vs Selling Price", x = "MMR", y = "Selling Price")

# Ensure directory exists before saving plots
dir.create("D:/Analytics/vehicle-sales-analysis/Res?lts/eda_visuals", recursive = TRUE, showWarnings = FALSE)

# Save plots
ggsave("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals/selling_price_distribution.png")
ggsave("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals/mmr_vs_selling_price.pn?")

print("??? EDA Completed!")

# ----------------------------- #
# ???? 3. Regression Model (Predicting Selling Price)
# ----------------------------- #

# Split into training (70%) and testing (30%)
set.seed(123)
index <- sample(1:nrow(data_final), round(nrow(data_final) * 0.7))
train <- data_final[index, ]
test  <- data_fin?l[-index, ]

# Build Regression Model
model <- lm(sellingprice ~ mmr + year + condition, data = train)

# Model Summary
summary(model)

# Save model
saveRDS(model, "D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/regression_model.rds")

print(???? Regression Model Training Completed!")

# ----------------------------- #
# ???? 4. Logistic Regression (Classifying Good vs. Bad Sales)
# ----------------------------- #

# Creating binary target variable
median_condition <- median(data_final$condition)
median_odometer <- median(data_final$odometer)
data_final$target_variable <- ifel?e(data_final$condition < median_condition & data_final$odometer > median_odometer, 0, 1)

# Split data
set.seed(123)
train_index <- sample(nrow(data_final), 0.7 * nrow(data_final))
train_data <- data_final[train_index, ]
test_data <- data_final[-train_inde?, ]

# Train Logistic Regression Model
logit_model <- glm(target_variable ~ year + transmission + condition + odometer + color + interior + mmr + sellingprice, 
                   family = binomial(link = "logit"), 
                   data = train_data)

#?Model Summary
summary(logit_model)

# Save Logistic Regression Model
saveRDS(logit_model, "D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/logistic_regression_model.rds")

print("??? Logistic Regression Model Training Completed!")

