install.packages("tidyverse")  # Install all required packages
library(ggplot2)
library(dplyr)

# ----------------------------- #
# 🔹 1. Data Preprocessing
# ----------------------------- #

# Read dataset
data <- read.csv("D:/Analytics/vehicle-sales-analysis/Data/Raw/dataset.csv")

# Remove missing values
clean_data <- na.omit(data)

# Drop unnecessary columns
columns_to_remove <- c("saledate", "body", "state", "seller", "trim", "make", "model", "vin")
data_final <- clean_data %>%
  select(-one_of(columns_to_remove))

# Convert categorical variables to factors
categorical_vars <- c("interior", "color", "transmission")
data_final[categorical_vars] <- lapply(data_final[categorical_vars], as.factor)

# Ensure directory exists before saving
dir.create("D:/Analytics/vehicle-sales-analysis/Data/Processed", recursive = TRUE, showWarnings = FALSE)

# Save cleaned dataset
write.csv(data_final, "D:/Analytics/vehicle-sales-analysis/Data/Processed/Cleaned_Dataset.csv", row.names = FALSE)

print("✅ Data Preprocessing Completed!")

# ----------------------------- #
# 🔹 2. Exploratory Data Analysis (EDA)
# ----------------------------- #

# Load cleaned data
data_final <- read.csv("D:/Analytics/vehicle-sales-analysis/Data/Processed/Cleaned_Dataset.csv")

# Summary statistics
summary(data_final)

# Histogram of Selling Price
ggplot(data_final, aes(x = sellingprice)) +
  geom_histogram(binwidth = 1000, fill = "blue", color = "black") +
  labs(title = "Distribution of Selling Prices", x = "Selling Price", y = "Frequency")

# Scatter plot of MMR vs Selling Price
ggplot(data_final, aes(x = mmr, y = sellingprice)) +
  geom_point(alpha = 0.5, color = "red") +
  labs(title = "MMR Value vs Selling Price", x = "MMR", y = "Selling Price")

# Ensure directory exists before saving plots
dir.create("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals", recursive = TRUE, showWarnings = FALSE)

# Save plots
ggsave("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals/selling_price_distribution.png")
ggsave("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals/mmr_vs_selling_price.png")

print("✅ EDA Completed!")

# ----------------------------- #
# 🔹 3. Regression Model (Predicting Selling Price)
# ----------------------------- #

# Split into training (70%) and testing (30%)
set.seed(123)
index <- sample(1:nrow(data_final), round(nrow(data_final) * 0.7))
train <- data_final[index, ]
test  <- data_final[-index, ]

# Build Regression Model
regression_model <- lm(sellingprice ~ mmr + year + condition, data = train)

# Model Summary
summary(regression_model)

# Ensure model evaluation directory exists
dir.create("D:/Analytics/vehicle-sales-analysis/Results/model_evaluation", recursive = TRUE, showWarnings = FALSE)

# Save Regression Model Summary
sink("D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/regression_model_summary.txt")
print(summary(regression_model))
sink()

# Save Regression Model
saveRDS(regression_model, "D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/regression_model.rds")

print("✅ Regression Model Training Completed!")

# ----------------------------- #
# 🔹 4. Logistic Regression (Classifying Good vs. Bad Sales)
# ----------------------------- #

# Creating binary target variable
median_condition <- median(data_final$condition)
median_odometer <- median(data_final$odometer)
data_final$target_variable <- ifelse(data_final$condition < median_condition & data_final$odometer > median_odometer, 0, 1)

# Split data into training and testing sets
set.seed(123)
train_index <- sample(nrow(data_final), 0.7 * nrow(data_final))
train_data <- data_final[train_index, ]
test_data <- data_final[-train_index, ]

# Train Logistic Regression Model
logit_model <- glm(target_variable ~ year + transmission + condition + odometer + color + interior + mmr + sellingprice, 
                   family = binomial(link = "logit"), 
                   data = train_data)

# Logistic Model Summary
sink("D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/logistic_regression_summary.txt")
print(summary(logit_model))
sink()

# Save Logistic Regression Model
saveRDS(logit_model, "D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/logistic_regression_model.rds")

# ----------------------------- #
# 🔹 5. Confusion Matrix (Logistic Regression Performance)
# ----------------------------- #

# Generate Predictions
predictions <- predict(logit_model, newdata = test_data, type = "response")

# Convert to binary classification (Threshold 0.5)
predicted_classes <- ifelse(predictions >= 0.5, 1, 0)

# Create Confusion Matrix
conf_matrix <- table(Predicted = predicted_classes, Actual = test_data$target_variable)

# Save Confusion Matrix as CSV
write.csv(as.data.frame(conf_matrix), "D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/confusion_matrix.csv", row.names = FALSE)

# Save Confusion Matrix as a Text File
sink("D:/Analytics/vehicle-sales-analysis/Results/model_evaluation/confusion_matrix.txt")
print(conf_matrix)
sink()

# Save Boxplots for Condition & Odometer Distribution
png("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals/boxplot_condition.png")
boxplot(data_final$condition, 
        main = "Distribution of Condition",
        ylab = "Condition",
        col = "skyblue",
        border = "black")
dev.off()

png("D:/Analytics/vehicle-sales-analysis/Results/eda_visuals/boxplot_odometer.png")
boxplot(data_final$odometer, 
        main = "Distribution of Odometer Reading",
        ylab = "Odometer Reading",
        col = "skyblue",
        border = "black")
dev.off()

print("✅ Logistic Regression Model Training & Confusion Matrix Saved!")