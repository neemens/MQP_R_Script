install.packages("data.table")
install.packages("tidyverse")
install.packages("writexl")
install.packages("readxl")
install.packages("minerva")

library(readxl)
library(tidyverse);
library(data.table);
library(writexl);
library(minerva)




testis_data <- read_excel("Testis_expression_data.xlsx", sheet = 2)# Read the data sets

# Extract the expression values for the  RFX isoform
rfx_isoform_1 <- testis_data[1, ] %>%
  select(-ensgid, -enstid)

rfx_isoform_1 <- as.numeric(unlist(rfx_isoform_1))# Convert to numeric values

# Prepare to store correlation results
isoform_1_results <- data.frame(Gene = character(),
                                Isoform = character(),
                                stringsAsFactors = FALSE)


for (i in 1:nrow(testis_data)) {# Loop through each brain isoform and compute correlation
  # Extract the expression values for the current brain isoform
  testis_isoform <- testis_data[i, ] %>%
    select(-ensgid, -enstid)
  
  testis_isoform <- as.numeric(unlist(testis_isoform)) # Convert to numeric values
  
  
  mic_value <- mine(rfx_isoform_1, testis_isoform)$MIC # perform MIC corrilation
  
  # Store the results
  isoform_1_results[i, "Gene"] <- as.character(testis_data$ensgid[i])
  isoform_1_results[i, "Isoform"] <- as.character(testis_data$enstid[i])
  isoform_1_results[i, "MIC"] <- mic_value
}

# Write the Excel file
write_xlsx(isoform_1_results, "mic_testis_RFX1.xlsx")

