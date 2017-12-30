#!/bin/bash

#
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE102385
# 

main(){
    set_variables
    create_folders
    # download_genome_and_annotations
    # download_reads
    subsample_reads
    # make_unwritetable
}

set_variables(){
    ROOT_FOLDER=Bacterial_data
    GENOME_AND_ANNOTATION_FOLDER=${ROOT_FOLDER}/genome_and_annotations
    RNASEQ_FOLDER=${ROOT_FOLDER}/reads
    RNASEQ_SUBSAMPLED_1M_FOLDER=${ROOT_FOLDER}/reads_subsample_1M
    RNASEQ_SUBSAMPLED_100k_FOLDER=${ROOT_FOLDER}/reads_subsample_100k
    GENOME_SOURCE=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/
    SRA_IDS_AND_LIB_NAMES="
SRR5912852=wildtype_Rep_1
SRR5912853=wildtype_Rep_2
SRR5912854=wildtype_Rep_3
SRR5912855=wildtype_Rep_4
SRR5912856=wildtype_Rep_5
SRR5912857=csrA_Rep_1
SRR5912858=csrA_Rep_2
SRR5912859=csrA_Rep_3
SRR5912860=csrA_Rep_4
SRR5912861=csrA_Rep_5
"
    
}

create_folders(){
    mkdir -p \
	${ROOT_FOLDER} \
	${GENOME_AND_ANNOTATION_FOLDER} \
	${RNASEQ_FOLDER} \
	${RNASEQ_SUBSAMPLED_100k_FOLDER} \
	${RNASEQ_SUBSAMPLED_1M_FOLDER}
}

download_genome_and_annotations(){
    wget -cP ${GENOME_AND_ANNOTATION_FOLDER} \
	${GENOME_SOURCE}/GCF_000005845.2_ASM584v2_genomic.gff.gz \
	${GENOME_SOURCE}/GCF_000005845.2_ASM584v2_genomic.fna.gz
    
    mv ${GENOME_AND_ANNOTATION_FOLDER}/GCF_000005845.2_ASM584v2_genomic.fna.gz \
       ${GENOME_AND_ANNOTATION_FOLDER}/GCF_000005845.2_ASM584v2_genomic.fa.gz
    gunzip ${GENOME_AND_ANNOTATION_FOLDER}/*gz
}

download_reads(){
    for SRA_ID_AND_LIB_NAME in ${SRA_IDS_AND_LIB_NAMES}
    do
	SRA_ID=$(echo ${SRA_ID_AND_LIB_NAME} | cut -f 1 -d"=")
	LIB_NAME=$(echo ${SRA_ID_AND_LIB_NAME} | cut -f 2 -d"=")
	fastq-dump \
	     --accession ${SRA_ID} \
	     --bzip2 \
	     --stdout \
	     > ${RNASEQ_FOLDER}/${LIB_NAME}.fastq.bz2 &
    done
    wait
}

subsample_reads(){
    for FASTQ_FILE in $(ls ${RNASEQ_FOLDER})
    do
	bzcat ${RNASEQ_FOLDER}/${FASTQ_FILE} \
	      | head -n 4000000 \
	      | bzip2 --stdout - \
	      > ${RNASEQ_SUBSAMPLED_1M_FOLDER}/$(echo ${FASTQ_FILE} | sed "s/.fastq/_1M.fastq/") &

	bzcat ${RNASEQ_FOLDER}/${FASTQ_FILE} \
	      | head -n 400000 \
	      | bzip2 --stdout - \
	      > ${RNASEQ_SUBSAMPLED_100k_FOLDER}/$(echo ${FASTQ_FILE} | sed "s/.fastq/_100k.fastq/") &
    done
    wait
}

main
