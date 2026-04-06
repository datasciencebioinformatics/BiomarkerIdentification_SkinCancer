########################################################################
# First phase, Tissue.Type
# Create DESeqDataSet from your prepared matrix
dds <- DESeqDataSetFromMatrix(countData = read_counts_table,
                              colData = sample_sheet_data,
                              design = ~ Tissue.Type)
# Run DeSeq2
dds <- DESeq(dds)

# Obtain the results
res_tumor_normal <- results(dds, contrast=c("Tissue.Type","Tumor","Normal"))

# Take 
res_tumor_normal<-data.frame(res_tumor_normal[which(res_tumor_normal$padj<0.05 & abs(res_tumor_normal$log2FoldChange)>2),])

# Write a data frame to Excel
write_xlsx(res_tumor_normal,  paste(project_folder,"Supplemental_Table_S1.xlsx",sep="" ))
########################################################################
# Second phase, Tissue.Type
# First phase, Tissue.Type
# Create DESeqDataSet from your prepared matrix
dds <- DESeqDataSetFromMatrix(countData = read_counts_table,
                              colData = sample_sheet_data,
                              design = ~ Tumor.Descriptor)

# Run DeSeq2
dds <- DESeq(dds)

# Obtain the results
res_Primary_normal <- results(dds, contrast=c("Tissue.Type","Primary","Normal"))
res_Primary_normal <- results(dds, contrast=c("Tissue.Type","Primary","Normal"))

