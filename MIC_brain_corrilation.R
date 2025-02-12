library(readxl)
library(tidyverse)
library(data.table)
library(writexl)
library(minerva)

# Read the data sets
average_brain_data <- read_excel("TPM_Averages_by_Brain_Region.xlsx", sheet = 1)

# Extract the expression values for the RFX isoform
rfx_isoform_1 <- average_brain_data[69296, ] %>%
  select(-ensgid, -enstid)

rfx_isoform_1 <- as.numeric(unlist(rfx_isoform_1)) # Convert to numeric values

# Prepare to store MIC results
isoform_1_results <- data.frame(Isoform = character(),
                                MIC = numeric(),
                                stringsAsFactors = FALSE)

# Loop through each brain isoform and compute MIC
for (i in 1:nrow(average_brain_data)) {
  # Extract the expression values for the current brain isoform
  brain_isoform <- average_brain_data[i, ] %>%
    select(-ensgid, -enstid)
  
  brain_isoform <- as.numeric(unlist(brain_isoform)) # Convert to numeric values
  
  # Perform the MIC calculation
  mic_value <- mine(rfx_isoform_1, brain_isoform)$MIC
  
  # Store the results
  isoform_1_results[i, "Isoform"] <- as.character(average_brain_data$enstid[i])
  isoform_1_results[i, "MIC"] <- mic_value
}

# Write the Excel file
write_xlsx(isoform_1_results, "mic_analysis_RFX1.xlsx")