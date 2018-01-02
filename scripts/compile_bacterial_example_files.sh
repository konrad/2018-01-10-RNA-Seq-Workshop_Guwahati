main(){
    readonly EXAMPLE_FILE_FOLDER=Bacterial_example_files
    readonly READEMPTION_FOLDER=READemption_analysis

    create_folder
    copy_genome_files
    subsample_fastq_file
    subsample_bam_file_to_sam_file
    tar_folder
}

create_folder(){
    mkdir -p ${EXAMPLE_FILE_FOLDER}
}

copy_genome_files(){
    cp \
	 ${READEMPTION_FOLDER}/input/annotations/GCF_000005845.2_ASM584v2_genomic.gff \
	 ${READEMPTION_FOLDER}/input/reference_sequences/GCF_000005845.2_ASM584v2_genomic.fa \
	 ${READEMPTION_FOLDER}/output/coverage/coverage-raw/csrA_Rep_1_forward.wig \
	 ${READEMPTION_FOLDER}/output/coverage/coverage-raw/csrA_Rep_1_reverse.wig \
	 ${EXAMPLE_FILE_FOLDER}
}

subsample_fastq_file(){
    bzcat ${READEMPTION_FOLDER}/input/reads/csrA_Rep_1.fastq.bz2 \
	| head -n 10000 \
	> ${EXAMPLE_FILE_FOLDER}/csrA_Rep_1.fastq
}

subsample_bam_file_to_sam_file(){
    samtools view -h ${READEMPTION_FOLDER}/output/align/alignments/csrA_Rep_1_alignments_final.bam \
	| head -n 100000 \
        > ${EXAMPLE_FILE_FOLDER}/csrA_Rep_1_alignments.sam
    samtools view -Shb ${EXAMPLE_FILE_FOLDER}/csrA_Rep_1_alignments.sam \
	     > ${EXAMPLE_FILE_FOLDER}/csrA_Rep_1_alignments.bam
}

tar_folder(){
    tar cvfj ${EXAMPLE_FILE_FOLDER}.tar.bz2 ${EXAMPLE_FILE_FOLDER}
}

main
