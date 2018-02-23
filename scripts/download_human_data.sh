#!/bin/bash

# 
# Used data RNA-Seq data set:
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE101756
# 
# Genome sequence and annotations (basic):
# https://www.gencodegenes.org/releases/current.html
#

main(){
    set_variables
    create_folders
    download_genome_and_annotations
    #download_reads
    subsample_reads
    extract_separeted_chromosome_data
    #tar_folder
}

set_variables(){
    ROOT_FOLDER=Human_data
    GENOME_AND_ANNOTATION_FOLDER=${ROOT_FOLDER}/genome_and_annotations
    RNASEQ_FOLDER=${ROOT_FOLDER}/reads
    RNASEQ_SUBSAMPLED_1M_FOLDER=${ROOT_FOLDER}/reads_subsample_1M
    RNASEQ_SUBSAMPLED_100k_FOLDER=${ROOT_FOLDER}/reads_subsample_100k
    GENOME_SOURCE=ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_27/
    LIB_SOURCE=ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR585/
    SRA_SUBPATHS_AND_LIB_NAMES="
007/SRR5859137/SRR5859137=Control_Rep_1
008/SRR5859138/SRR5859138=Control_Rep_2
009/SRR5859139/SRR5859139=Control_Rep_3
000/SRR5859140/SRR5859140=Control_Rep_4
001/SRR5859141/SRR5859141=Benta_Rep_1
002/SRR5859142/SRR5859142=Benta_Rep_2
003/SRR5859143/SRR5859143=Benta_Rep_3
004/SRR5859144/SRR5859144=Benta_Rep_4
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
	 ${GENOME_SOURCE}/GRCh38.p10.genome.fa.gz \
	 ${GENOME_SOURCE}/gencode.v27.basic.annotation.gff3.gz \
	 ${GENOME_SOURCE}/gencode.v27.pc_transcripts.fa.gz \
     ${GENOME_SOURCE}/gencode.v27.annotation.gtf.gz
    gunzip ${GENOME_AND_ANNOTATION_FOLDER}/*gz
}

download_reads(){
    for SRA_SUBPATH_AND_LIB_NAME in ${SRA_SUBPATHS_AND_LIB_NAMES}
    do
	SRA_SUBPATH=$(echo ${SRA_SUBPATH_AND_LIB_NAME} | cut -f 1 -d"=")
	LIB_NAME=$(echo ${SRA_SUBPATH_AND_LIB_NAME} | cut -f 2 -d"=")
	for READ in 1 2
	do
	    wget -c \
		 -O ${RNASEQ_FOLDER}/${LIB_NAME}_R${READ}.fastq.gz \
		 ${LIB_SOURCE}/${SRA_SUBPATH}_${READ}.fastq.gz
	done
    done
    wait
}

extract_separeted_chromosome_data(){
    grep -P "^#|chr1\t" ${GENOME_AND_ANNOTATION_FOLDER}/gencode.v27.basic.annotation.gff3 \
	 > ${GENOME_AND_ANNOTATION_FOLDER}/gencode.v27.basic.annotation_chr1.gff3
    grep -P "^#|chr20\t" ${GENOME_AND_ANNOTATION_FOLDER}/gencode.v27.basic.annotation.gff3 \
	 > ${GENOME_AND_ANNOTATION_FOLDER}/gencode.v27.basic.annotation_chr20.gff3

    head -n 4149275 ${GENOME_AND_ANNOTATION_FOLDER}/GRCh38.p10.genome.fa \
	 > ${GENOME_AND_ANNOTATION_FOLDER}/GRCh38.p10.genome_chr1.fa
    head -n 46291249 ${GENOME_AND_ANNOTATION_FOLDER}/GRCh38.p10.genome.fa \
	| tail -n 1074071 \
    	 > ${GENOME_AND_ANNOTATION_FOLDER}/GRCh38.p10.genome_chr20.fa
}

subsample_reads(){
    for FASTQ_FILE in $(ls ${RNASEQ_FOLDER})
    do
	zcat ${RNASEQ_FOLDER}/${FASTQ_FILE} \
	      | head -n 4000000 \
	      | gzip --stdout - \
	      > ${RNASEQ_SUBSAMPLED_1M_FOLDER}/$(echo ${FASTQ_FILE} | sed "s/.fastq/_1M.fastq/") &

	zcat ${RNASEQ_FOLDER}/${FASTQ_FILE} \
	      | head -n 400000 \
	      | gzip --stdout - \
	      > ${RNASEQ_SUBSAMPLED_100k_FOLDER}/$(echo ${FASTQ_FILE} | sed "s/.fastq/_100k.fastq/") &
    done
    wait
}

tar_folder(){
    tar cf ${ROOT_FOLDER}.tar ${ROOT_FOLDER}
}

main
