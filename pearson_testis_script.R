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

# Extract the expression values for the RFX isoform
rfx_isoform_3 <- testis_data[1, ] %>%
  select(-ensgid, -enstid)

rfx_isoform_3 <- as.numeric(unlist(rfx_isoform_3))# Convert to numeric values

# Prepare to store correlation results
isoform_3_results <- data.frame(Gene = character(),
                                Isoform = character(),
                                P_Value = numeric(),
                                
                                stringsAsFactors = FALSE)


for (i in 1:nrow(testis_data)) {# Loop through each brain isoform and compute correlation
  # Extract the expression values for the current brain isoform
  testis_isoform <- testis_data[i, ] %>%
    select(-ensgid, -enstid)
  
  testis_isoform <- as.numeric(unlist(testis_isoform)) # Convert to numeric values
  
  
  cor_test <- cor.test(rfx_isoform_3, testis_isoform,method = "pearson") #perform pearson corrilation
  
  # Store the results
  isoform_3_results[i, "Gene"] <- as.character(testis_data$ensgid[i])
  isoform_3_results[i, "Isoform"] <- as.character(testis_data$enstid[i])
  isoform_3_results[i, "P_Value"] <- cor_test$p.value
  isoform_3_results[i, "pearson"] <- cor_test$estimate
}

# Write the Excel file
write_xlsx(isoform_3_results, "pearson_testis_RFX1.xlsx")

