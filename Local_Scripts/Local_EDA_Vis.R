#Install required libraries
#install.packages(c("ggplot2", "gridExtra", "GGally", "RColorBrewer", "dplyr"))

# Load the required libraries
library(ggplot2)
library(gridExtra)
library(GGally)
library(RColorBrewer)
library(dplyr)

setwd("C:/Users/") #Insert your ImageJ macro output directory here) # nolint

# Read the combined_data.csv file
combined_data <- read.csv("combined_data.csv", fileEncoding = "UTF-8")

# EDA - Summary statistics by Condition
summary_by_condition <- combined_data %>%
  group_by(Condition) %>%
  summarise(
    Mean_Mean_Fluorescence = mean(Mean_Fluorescence),
    Mean_Circularity = mean(Circularity),
    Mean_Area = mean(Area_um),
    Mean_Diameter = mean(Diameter_um),
    Count_Titan_Cells = sum(Diameter_um > 10),
    Proportion_Titan_Cells = (Count_Titan_Cells / n()) * 100,
    Count_Titanides_Cells = sum(Diameter_um < 3),
    Proportion_Titanides_Cells = (Count_Titanides_Cells / n()) * 100
  )

# Create EDA plots
# Box plots for Mean_Fluorescence by Condition
ggplot(combined_data, aes(x = Condition, y = Mean_Fluorescence)) +
  geom_boxplot() +
  labs(title = "Mean Fluorescence by Condition", y = "Mean Fluorescence")

ggsave("boxplot_mean_fluorescence.png", device = "png", width = 8, height = 6)

# Scatter plot of Diameter vs Mean_Fluorescence colored by Condition
diameter_vs_mean_fluorescence_plot <- ggplot(combined_data, aes(x = `Diameter_um`, y = Mean_Fluorescence, color = Condition)) + # nolint
  geom_point() +
  labs(title = "Scatter Plot of Diameter vs Mean Fluorescence", x = "Diameter (µm)", y = "Mean Fluorescence") # nolint

# Add a red dashed line at 10 micrometers (to show titan cells) and blue at 3 micrometers (to show titanides) # nolint
diameter_vs_mean_fluorescence_plot +
  geom_vline(xintercept = 10, linetype = "dashed", color = "red") +
  annotate("text", x = 10, y = max(combined_data$Mean_Fluorescence), label = ">10 µm", hjust = -0.2, colour = "red") + # nolint
  geom_vline(xintercept = 3, linetype = "dashed", color = "blue") +
  annotate("text", x = 3, y = max(combined_data$Mean_Fluorescence), label = "<3 µm", hjust = 1.2, colour = "blue") # nolint


ggsave("scatterplot_diameter_vs_mean_fluorescence.png", device = "png", width = 8, height = 6) # nolint # nolint

# Scatter plot of Diameter vs Area colored by Condition
diameter_vs_area_plot <- ggplot(combined_data, aes(x = `Diameter_um`, y = `Area_um`, color = Condition)) + # nolint
  geom_point() +
  labs(title = "Scatter Plot of Diameter vs Area", x = "Diameter (µm)", y = "Area (µm^3)") # nolint

# Add a red dashed line at 10 micrometers (to show titan cells) and blue at 3 micrometers (to show titanides) # nolint
diameter_vs_area_plot +
  geom_vline(xintercept = 10, linetype = "dashed", color = "red") +
  annotate("text", x = 10, y = max(combined_data$Mean_Fluorescence), label = ">10 µm", hjust = -0.2, colour = "red") + # nolint
  geom_vline(xintercept = 3, linetype = "dashed", color = "blue") +
  annotate("text", x = 3, y = max(combined_data$Mean_Fluorescence), label = "<3 µm", hjust = 1.2, colour = "blue") # nolint


ggsave("scatterplot_diameter_vs_area.png", device = "png", width = 8, height = 6) # nolint

# Proportion of Titan Cells by Condition as a percentage with actual values on bars # nolint: line_length_linter.
proportion_titan_cells_plot <- ggplot(summary_by_condition, aes(x = Condition, y = Proportion_Titan_Cells)) + # nolint
  geom_bar(stat = "identity") +
  labs(title = "Proportion of Titan Cells by Condition", x = "Condition", y = "Proportion of Titan Cells (%(#))") # nolint

# Add actual values on bars
proportion_titan_cells_plot +
  geom_text(aes(label = sprintf("%.2f (%d)", Proportion_Titan_Cells, Count_Titan_Cells)), vjust = -0.5, size = 3)+ #nolint
  theme(axis.text.x = element_text(angle = 45, hjust=1)) # nolint

ggsave("proportion_titan_cells.png", device = "png", width = 8, height = 6)

# Proportion of Titanides Cells by Condition as a percentage with actual values on bars # nolint: line_length_linter.
proportion_titanides_cells_plot <- ggplot(summary_by_condition, aes(x = Condition, y = Proportion_Titanides_Cells)) + # nolint
  geom_bar(stat = "identity") +
  labs(title = "Proportion of Titanides Cells by Condition", x = "Condition", y = "Proportion of Titanides Cells (%(#))") # nolint

# Add actual values on bars
proportion_titanides_cells_plot +
  geom_text(aes(label = sprintf("%.2f (%d)", Proportion_Titanides_Cells, Count_Titanides_Cells)), vjust = -0.5, size = 3)+ #nolint
  theme(axis.text.x = element_text(angle = 45, hjust=1)) # nolint

ggsave("proportion_titanides_cells.png", device = "png", width = 8, height = 6)

# Perform statistical tests if needed (e.g., ANOVA, t-tests) to compare conditions # nolint
# WIP

# Create the scatter plot matrix with regression lines and R-squared values
scatter_plot_matrix <- ggpairs(combined_data, columns = c("Mean_Fluorescence", "Circularity", "Area_um", "Diameter_um"), # nolint
                               aes(color = Condition),
                               upper = list(continuous = wrap("points", size = 2, alpha = 0.3)), # nolint # nolint
                               lower = list(continuous = wrap("points", size = 2, alpha = 0.3)), # nolint
                               diag = list(continuous = wrap("densityDiag"), discrete = "barDiag"), # nolint
                               title = "Scatter Plot Matrix")

# Display the final plot
print(scatter_plot_matrix)

# Save the scatter_plot_matrix to an image file (e.g., in PNG format)
ggsave("scatter_plot_matrix.png", plot = scatter_plot_matrix, width = 10, height = 10, units = "in") # nolint

print("Completed EDA and Visualisation")