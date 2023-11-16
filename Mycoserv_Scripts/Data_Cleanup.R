#Install required libraries
install.packages(c("dplyr", "stringr", "readr", "tidyr"))

# Load the required libraries
library(dplyr)
library(stringr)
library(readr)
library(tidyr)

# List all CSV files in the directory
csv_files <- list.files(CSV_DIRECTORY, pattern = "\\.csv$", full.names = TRUE)

# Create an empty list to store the processed data frames
processed_data_list <- list()

# Loop through each CSV file
for (file in csv_files) {
  # Read the CSV file, skipping the last row
  data <- read.csv(text = paste0(head(readLines(file), -1), collapse = "\n"))
  data$ID <- seq.int(nrow(data))

  # Select and rename columns
  data <- data %>%
    select(Label, Mean, Circ., Area, Feret, ID) %>%
    rename(
      Condition = Label,
      Mean_Fluorescence = Mean,
      Circularity = Circ.,
      Area_um = Area,
      Diameter_um = Feret,
      Cell_ID = ID
    )

  # Extract and format the Condition column

  # Split label column into EB naming scheme
  data <- data %>%
    separate(Condition, into = c("Date", "Strain", "Condition", "Time", "Stain", "Rep", "Image"), sep = "_") # nolint

  # Generate the output file name
  output_file <- paste0(data$Condition[1], "_processed_data.csv")

  # Save the processed data to a new CSV file
  write_csv(data, file.path(csv_directory, output_file))

  cat(paste("Processed file:", file, "=>", output_file, "\n"))

  # Store the processed data frame in the list
  processed_data_list[[length(processed_data_list) + 1]] <- data
}

# Combine all processed data frames into one
combined_data <- do.call(rbind, processed_data_list)

# Save the combined data to a single CSV file
write_csv(combined_data, file.path(csv_directory, "combined_data.csv"))