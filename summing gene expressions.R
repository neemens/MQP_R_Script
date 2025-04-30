install.packages("data.table")
install.packages("tidyverse")
install.packages("writexl")
install.packages("readxl")

library(readxl)
library(tidyverse);
library(data.table);
library(writexl);


# Read the data sets

average_brain_data <- read_excel("TPM_Averages_by_Brain_Region.xlsx", sheet = 1)

# Exclude genes RFX1-7
data_filtered <- average_brain_data[!average_brain_data$ensgid %in% c(
  "ENSG00000132005", "ENSG00000087903", "ENSG00000080298", 
  "ENSG00000143390", "ENSG00000181827"
), ]

# Summing expression values across isoforms for each gene
summed_expression_data <- data_filtered %>%
  group_by(ensgid) %>%
  summarise(across(where(is.numeric), sum, na.rm = TRUE))

# Save the aggregated data
write.csv(summed_expression_data, "summed_expression_data.csv", row.names = FALSE)

# Print the first few rows to verify
head(summed_expression_data)

