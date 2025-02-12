install.packages("data.table")
install.packages("tidyverse")
install.packages("openxlsx")

library(data.table);
library(tidyverse);
library(openxlsx)

# load the tissue isoform expression data
tissue_data <- fread("transcript_rna_tissue.tsv", sep = "\t");
str(tissue_data);

print(colnames(tissue_data))


Testis_samples <- tissue_data[, c("ensgid", "enstid", "TPM.testis.244", "TPM.testis.278",	"TPM.testis.279",	"TPM.testis.280",	"TPM.testis.281",	"TPM.testis.282",	"TPM.testis.283",	"TPM.testis.349",	"TPM.testis.371",	"TPM.testis.354")]# Filter the relevant columns: 'ensgid', 'enstid', 'tests'


output_file_path <- "Testis_expression_data.xlsx"# Specify the path and name of the new CSV file


write.xlsx(Testis_samples, output_file_path)# Write the filtered data to the new CSV file


cat("Filtered data written to:", output_file_path)


