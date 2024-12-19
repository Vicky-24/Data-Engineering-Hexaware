# Databricks notebook source
from pyspark.sql import SparkSession

# Initialize Spark session
spark = SparkSession.builder.appName("TimeSeriesAnalysis").getOrCreate()

# Load the dataset from Databricks Delta table location
file_path = "dbfs:/user/hive/warehouse/delta_training.db/daily_minimum"
df = spark.read.format('delta').load(file_path)

# Show the first few rows of the dataset
df.show(5)


# COMMAND ----------

from pyspark.sql.functions import to_date, col

# Convert the timestamp column to a date format
df = df.withColumn("Date", to_date(col("Date"), "yyyy-MM-dd"))

# Drop rows with missing values
df = df.dropna()

# Sort data by date
df = df.orderBy("Date")

# Display the cleaned data
df.show(5)


# COMMAND ----------

from pyspark.sql.functions import year, month, avg, col

# Extract year and month
df = df.withColumn("Year", year(col("Date"))).withColumn("Month", month(col("Date")))

# Calculate monthly average temperature using the correct column name
monthly_trends = df.groupBy("Year", "Month").agg(avg(col("Daily minimum temperatures")).alias("Average_Temp"))
monthly_trends.show(10)


# COMMAND ----------

from pyspark.sql.functions import avg, col

# Aggregate by month to find seasonal trends using the correct column name
seasonality = df.groupBy("Month").agg(avg(col("Daily minimum temperatures")).alias("Average_Temp"))
seasonality.show()


# COMMAND ----------

from pyspark.sql.functions import mean, stddev, col

# Calculate mean and standard deviation for 'Daily minimum temperatures'
stats = df.select(mean("Daily minimum temperatures").alias("mean"), stddev("Daily minimum temperatures").alias("stddev")).collect()
mean_val, stddev_val = stats[0]["mean"], stats[0]["stddev"]

# Add a Z-score column
df = df.withColumn("Z_score", (col("Daily minimum temperatures") - mean_val) / stddev_val)

# Filter anomalies (e.g., Z-score > 3 or < -3)
anomalies = df.filter((col("Z_score") > 3) | (col("Z_score") < -3))
anomalies.show()


# COMMAND ----------

# Convert Spark DataFrames to Pandas for visualization
pandas_trends = monthly_trends.toPandas()
pandas_seasonality = seasonality.toPandas()
pandas_anomalies = anomalies.toPandas()

import matplotlib.pyplot as plt

# Plot trends
plt.figure(figsize=(12, 6))
plt.plot(pandas_trends["Month"], pandas_trends["Average_Temp"], label="Monthly Avg Temp")
plt.title("Trend Analysis")
plt.xlabel("Month")
plt.ylabel("Average Temperature")
plt.legend()
plt.show()

# Plot seasonality
plt.figure(figsize=(8, 4))
plt.bar(pandas_seasonality["Month"], pandas_seasonality["Average_Temp"])
plt.title("Seasonality Analysis")
plt.xlabel("Month")
plt.ylabel("Average Temperature")
plt.show()

# Highlight anomalies
# Check column names to ensure correct one is used
print(pandas_anomalies.columns)

# Assuming 'Date' and 'Daily minimum temperatures' are the correct columns
plt.figure(figsize=(12, 6))
plt.scatter(pandas_anomalies["Date"], pandas_anomalies["Daily minimum temperatures"], color="red", label="Anomalies")
plt.title("Anomaly Detection")
plt.xlabel("Date")
plt.ylabel("Temperature")
plt.legend()
plt.show()


# COMMAND ----------

