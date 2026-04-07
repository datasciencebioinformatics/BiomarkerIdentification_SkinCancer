# Construct PCA
# 2. Basic plot
# 1. Transform data (vst is recommended for large datasets)
vsd <- vst(dds_tumor_genes, blind = FALSE)

# 1. Extract PCA data
pcaData <- plotPCA(vsd, intgroup = c("Tissue.Type"), returnData = TRUE)

# 2. Calculate percentage of variance for axis labels
percentVar <- round(100 * attr(pcaData, "percentVar"))

# Melt tabele
# Plot_raw_vibration_data.png                                                                                                            
png(filename=paste(project_folder,"PCA_Plot_of_RNASeq_Samples_TissueType.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # 3. Create custom ggplot
  ggplot(pcaData, aes(x = PC1, y = PC2, color = group)) +
    geom_point(size = 3) +
    xlab(paste0("PC1: ", percentVar[1], "% variance")) +
    ylab(paste0("PC2: ", percentVar[2], "% variance")) +
    coord_fixed() +
    theme_minimal()
dev.off()


#######################################################################################################################################
# Construct venn diagram                                                                                                                               #                                                       #
# Select stages 
stages_tumor_primary_metastatic<-ggVennDiagram(list(tumor_normal    =res_tumor_normal$Gene,primary_normal  =res_Primary_normal$Gene, metastatic_normal  =res_Metastatic_normal$Gene), label_alpha = 0) + scale_fill_viridis() + theme_bw() + ggtitle("tumor, primary and metastatic")

# Melt tabele
# Plot_raw_vibration_data.png                                                                                                            
png(filename=paste(project_folder,"VennDiagram_Plot_of_RNASeq_Samples_TissueType.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # 3. Create custom ggplot
  stages_tumor_primary_metastatic +    theme_minimal()
dev.off()
#######################################################################################################################################
# Biomarkers whose fold change (FC) was ≥50 and average TPM of control samples ≤ 10.
# First, compile data.frame with 
# Take p-value
df_mean<-data.frame(
    ENSEMBL=stage_specific_genes$ENSEMBL,
    ENTREZID=stage_specific_genes$ENTREZID,
    SYMBOL=stage_specific_genes$SYMBOL,
    avg.normal=rowMeans(unstranded_data[stage_specific_genes$gene,sample_normal]),
    std.normal=0,
    avg.stageI=rowMeans(unstranded_data[stage_specific_genes$gene,sample_stage_I]),
    std.stageI=0, 
    avg.stageII=rowMeans(unstranded_data[stage_specific_genes$gene,sample_stage_II]), 
    std.stageII=0, 
    avg.stageIII=rowMeans(unstranded_data[stage_specific_genes$gene,sample_stage_III]), 
    std.stageIII=0)



# Save list
sheets_list <- list("tumor_genes"= res_tumor_normal, "primary_tumor_genes" = res_Primary_normal, "metastatic_tumor_genes"=res_Metastatic_normal)
write_xlsx(sheets_list,paste(project_folder,"Supplemental_Table_S1.xlsx",sep="" ))
