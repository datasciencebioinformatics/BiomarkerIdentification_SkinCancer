###################################################################################
# Set the project configuration
# Set the path to manifest file
Manifest_file=paste(project_folder,"metadata/gdc_manifest.2026-04-05.155802.txt",sep="")

# Set the path to Sample sheet file
Sample_sheet_file=paste(project_folder,"metadata/gdc_sample_sheet.2026-04-05.tsv",sep="")

# Set the path to Sample sheet filtered file
Sample_sheet_filtered_file=paste(project_folder,"metadata/gdc_sample_sheet_star_gene_counts.tsv",sep="")

# Take the list of gene ids
gene_ids_file<-paste(project_folder,"metadata/gene_ids.txt",sep="")
###################################################################################
# Load sample sheet data
sample_sheet_data<-read.delim(file = Sample_sheet_filtered_file, sep = '\t', header = TRUE,fill=TRUE)

# Load gene ids data
gene_ids_data<-read.delim(file = gene_ids_file, sep = '\t', header = TRUE,fill=TRUE)
###################################################################################
# Star dataframe with all gene ids
read_counts_table<-data.frame(gene_id=as.vector(gene_ids_data[,1]))

# Set rownames
rownames(read_counts_table)<-read_counts_table$gene_id

# Set rownames of 
rownames(sample_sheet_data)<-sample_sheet_data$File.ID

# For each file in the sample_sheet_data, read the gene counts data
for (sample in rownames(sample_sheet_data))
{
  # Take the file id
  file_id<-sample_sheet_data[sample,"File.ID"]

  # Take the name of the file
  file_name<-sample_sheet_data[sample,"File.Name"]

  # Read the counts table
  counts_table<-read.delim(paste(project_folder,"data/",file_name,sep=""), skip = 5)

  # Set the colnames
  colnames(counts_table)<-c("gene_id",	"gene_name",	"gene_type",	"unstranded",	"stranded_first",	"stranded_second",	"tpm_unstranded",	"fpkm_unstranded",	"fpkm_uq_unstranded")

  # Set rownames
  rownames(counts_table)<-counts_table$gene_id

  # Start data.frame for the table
  df_counts_table<-data.frame(file_id=counts_table[rownames(counts_table),"unstranded"])

  # Set file_id in the colname
  colnames(df_counts_table)<-file_id

  # Add to table
  read_counts_table<-cbind(read_counts_table,df_counts_table)
}
# Remove first collumn
read_counts_table<-read_counts_table[,-1]
