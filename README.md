Vehicle Sales Analysis
Predicting Vehicle Prices and Classifying Sales Using Regression Models

Project Overview
This project analyzes vehicle sales data to:

1) Predict vehicle selling prices using multiple regression models
2) Classify sales as "Good" or "Bad" using logistic regression
3) Perform Exploratory Data Analysis (EDA) to understand key trends

The dataset is sourced from Kaggle and contains 558,838 rows & 16 columns covering vehicle features, sales prices, and market trends.


Project Structure

📂 vehicle-sales-analysis/
├── 📂 data/                            # Dataset Storage
│   ├── 📂 raw/                         # Raw Data
│   ├── 📂 processed/                    # Cleaned Data
│
├── 📂 scripts/                         # R Scripts for Analysis
│   ├── data_preprocessing.R            # Cleans and processes data
│   ├── exploratory_analysis.R          # Performs EDA
│   ├── regression_model.R              # Predicts selling price
│   ├── logistic_regression_model.R     # Classifies sales
│   ├── main_analysis.R                 # Runs full analysis
│
├── 📂 results/                         # Stores analysis results
│   ├── 📂 eda_visuals/                  # EDA Visualizations
│   ├── 📂 model_evaluation/              # Model Summaries and Metrics
│
├── README.md                           # Project Documentation
├── requirements.txt                     # List of R Packages Used
└── .gitignore                           # Files to Ignore in GitHub


Key Research Questions

1. What is the best model to predict vehicle selling prices?

Approach: Multiple Linear Regression
Key Predictors: MMR, Year, Condition
Best Model: Selected based on Adjusted R² and Residual Sum of Squares (RSS)

2. Do interaction terms improve prediction?

Tested Interactions: Condition × Year, MMR × Odometer
Result: Interaction terms did not significantly improve model performance

3. Can we classify sales as "Good" or "Bad"?

Approach: Logistic Regression
Target: Sales classified using Condition & Odometer
Performance: Accuracy, Precision, Recall, Confusion Matrix


How to Run the Project

1. Install Required R Packages

install.packages(c("tidyverse", "ggplot2", "dplyr", "leaps"))

2. Run the Main Analysis Script

source("scripts/main_analysis.R")

This will:
Clean the dataset
Perform EDA
Train & evaluate models
Save results in the results/ folder


Key Results & Insights

📌 Regression Model

Best predictors: MMR, Year, Condition
Achieved Adjusted R² of 0.9697

📌 Logistic Regression Model

Accuracy: 88.37%
Confusion Matrix saved in results/model_evaluation/

📌 EDA Insights

Better condition = higher selling price
Higher odometer readings reduce resale value
Market Report Prices (MMR) strongly influence final selling price


Future Improvements

Try Random Forest or XGBoost for better predictions
Optimize feature selection
Test on larger datasets


Author & Credits

Author: [Your Name]
Dataset: Kaggle - Vehicle Sales Data
GitHub Repository: [Your GitHub Link]