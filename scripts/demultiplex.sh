#Get files from HTSEQ


#Make tsv with sample names in first column and two barcodes joined by a hyphen (i7-i5) in second, for demultiplexing
awk '{print $1 "\t" $9 "-" $12}' < /Genomics/ayroleslab2/shared/genomics-in-the-wild-2024/data/giw2024/metadata.txt > barcodes_fmtd.fil

#Get fastq-multx from github
git clone https://github.com/brwnj/fastq-multx
cd fastq-multx
make

#Run the demultiplexing (on files in 01_raw_fastqs)
fastq_demux -B /Genomics/ayroleslab2/shared/genomics-in-the-wild-2024/data/giw2024/metadata.txt \
-m 0 \
--R1 /Genomics/ayroleslab2/shared/genomics-in-the-wild-2024/data/giw2024/J1_S1_L001_R1_001.fastq.gz \
--R2/Genomics/ayroleslab2/shared/genomics-in-the-wild-2024/data/giw2024/J1_S1_L001_R2_001.fastq.gz \
-o n/a \
-o n/a \
-o 02_demultiplexed_fastqs/%_R1.fastq \
-o 02_demultiplexed_fastqs/%_R2.fastq