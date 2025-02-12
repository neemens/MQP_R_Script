install.packages("data.table")
install.packages("tidyverse")
install.packages("writexl")

library(data.table);
library(tidyverse);
library(writexl);

# Load the data
brain_data <- fread("transcript_rna_brain.tsv", sep = "\t")


tpm_data <- brain_data %>%
  select(ensgid, enstid, starts_with("TPM."))# Select columns that start with "TPM." and include 'ensgid' and 'enstid'


tpm_data_long <- melt(tpm_data, id.vars = c("ensgid", "enstid"), variable.name = "region", value.name = "expression")# Extract the brain region names and average the columns 


tpm_data_long[, region := sub("^TPM\\.([^\\.]+)\\..*", "\\1", region)]# Extract the brain region name (between "TPM." and the second ".")

# Calculate the mean expression by 'ensgid', 'enstid', and 'region'
tpm_averages <- tpm_data_long[, .(mean_expression = mean(expression, na.rm = TRUE)), by = .(ensgid, enstid, region)]


tpm_averages_wide <- dcast(tpm_averages, ensgid + enstid ~ region, value.var = "mean_expression")# Reshaping the data

# Write the resulting data to an Excel file
output_file_path <- "TPM_Averages_by_Brain_Region.xlsx"
write_xlsx(tpm_averages_wide, output_file_path)

cat("Averages by brain region written to:", output_file_path)
