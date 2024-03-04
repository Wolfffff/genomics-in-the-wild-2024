#Get files from HTSEQ


#Make tsv with sample names in first column and two barcodes joined by a hyphen (i7-i5) in second, for demultiplexing
awk '{print $1 "\t" $2 "-" $3}' < barcodes_all.tsv > barcodes_fmtd.fil

#Get fastq-multx from github
git clone https://github.com/brwnj/fastq-multx
cd fastq-multx
make

#Run the demultiplexing (on files in 01_raw_fastqs)
./fastq-multx -B barcodes_fmtd.fil \
-m 1 \
INFO-000000000-DHCH6_1_Read_2_Index_Read_passed_filter.fastq.gz \
INFO-000000000-DHCH6_1_Read_3_Index_Read_passed_filter.fastq.gz \
INFO-000000000-DHCH6_1_Read_1_passed_filter.fastq.gz \
INFO-000000000-DHCH6_1_Read_4_passed_filter.fastq.gz \
-o n/a \
-o n/a \
-o 02_demultiplexed_fastqs/%_R1.fastq \
-o 02_demultiplexed_fastqs/%_R2.fastq