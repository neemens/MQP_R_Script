install.packages("data.table")
install.packages("tidyverse")
install.packages("writexl")
install.packages("readxl")

library(readxl)
library(tidyverse);
library(data.table);
library(writexl);

summed_expression_data <- read_excel("summed_gene_expression_data.xlsx")

# Extract the expression values for the  RFX isoform
rfx_isoform_1 <- summed_expression_data[5, ] %>%
  select(-ensgid, -enstid)

rfx_isoform_1 <- as.numeric(unlist(rfx_isoform_1))# Convert to numeric values

# Prepare to store correlation results
isoform_1_results <- data.frame(Gene = character(),
                                P_Value = numeric(),
                                Correlation = numeric(),
                                stringsAsFactors = FALSE)


for (i in 1:nrow(summed_expression_data)) {# Loop through each brain isoform and compute Spearman correlation
  # Extract the expression values for the current brain isoform
  brain_isoform <- summed_expression_data[i, ] %>%
    select(-ensgid, -enstid)
  
  brain_isoform <- as.numeric(unlist(brain_isoform)) # Convert to numeric values
  
  
  cor_test <- cor.test(rfx_isoform_1, brain_isoform, method = "spearman")# Perform Spearman correlation test
  
  # Store the results 
  isoform_1_results[i, "Gene"] <- as.character(summed_expression_data$ensgid[i])
  isoform_1_results[i, "P_Value"] <- cor_test$p.value
  isoform_1_results[i, "Correlation"] <- cor_test$estimate
}


# Write the Excel file 
write_xlsx(isoform_1_results, "summed_spearman_corrilation_analysis_RFX7.xlsx")



