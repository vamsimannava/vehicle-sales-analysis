# Load necessary libraries
library(dplyr)

# Read dataset
data <- read.csv("D:\\Analytics\\vehicle-sales-analysis\\data\\raw\\dataset.csv")

# Remove missing values
clean_data <- na.omit(data)

# Drop unnecessary columns
columns_to_remove <- c("saledate", "body", "state", "seller", "trim", "make", "model", "vin")
data_final <- clean_data %>%
  select(-one_of(columns_to_remove))

# Convert categorical variables to factors
categorical_vars <- c("interior", "color", "transmission")
data_final[categorical_vars] <- lapply(data_final[categorical_vars], as.factor)

write.csv(data_final, "data/processed/cleaned_dataset.csv", row.names = FALSE)
# Ensure the directory exists before saving the file
dir.create("D:/Analytics/vehicle-sales-analysis/Data/Processed", recursive = TRUE, showWarnings = FALSE)

# Save the cleaned dataset
write.csv(data_final, "D:/Analytics/vehicle-sales-analysis/Data/Processed/cleaned_vehicle_sales.csv", row.names = FALSE)

