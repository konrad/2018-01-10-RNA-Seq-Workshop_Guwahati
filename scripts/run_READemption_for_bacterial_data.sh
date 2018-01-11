#!/usr/bin/env bash

main(){
    readonly READEMPTION_FOLDER=READemption_analysis
    readonly REF_SEQ_FOLDER=${READEMPTION_FOLDER}/input/reference_sequences/
    readonly ANNOTATION_FOLDER=${READEMPTION_FOLDER}/input/annotations
    readonly READ_LIB_FOLDER=${READEMPTION_FOLDER}/input/reads
    readonly MAPPING_PROCESSES=40
    readonly COVERAGE_PROCESSES=40
    readonly GENE_QUANTI_PROCESSES=40
    readonly REF_SEQ_SOURCE=${PWD}/Bacterial_data/genome_and_annotations/GCF_000005845.2_ASM584v2_genomic.fa
    readonly ANNOTATION_SOURCE=${PWD}/Bacterial_data/genome_and_annotations/GCF_000005845.2_ASM584v2_genomic.gff
    readonly READ_LIB_SOURCE=${PWD}/Bacterial_data/reads/
    # readonly READ_LIB_SOURCE=${PWD}/Bacterial_data/reads_subsample_1M/    
    # readonly READ_LIB_SOURCE=${PWD}/Bacterial_data/reads_subsample_100k/
    
    set_up_analysis_folder
    link_genome_fasta_file
    link_gff_file
    link_libraries
    run_read_alignment
    build_coverage_files
    run_gene_quanti
    run_deseq_analysis
    run_viz_align
    run_viz_gene_quanti
    run_viz_deseq
}
set_up_analysis_folder(){
    reademption create ${READEMPTION_FOLDER}
}

link_genome_fasta_file(){
    ln -s  ${REF_SEQ_SOURCE} ${REF_SEQ_FOLDER}/
}

link_gff_file(){
    ln -s ${ANNOTATION_SOURCE} ${ANNOTATION_FOLDER}/
}

link_libraries(){
    for LIB in ${READ_LIB_SOURCE}/*
    do
        ln -s ${LIB} ${READ_LIB_FOLDER}
    done
}

run_read_alignment(){
    reademption \
        align \
        --process ${MAPPING_PROCESSES} \
        --segemehl_accuracy 95 \
        --min_read_length 20 \
	--progress \
	--fastq \
	--adapter CTGTAGGCAC \
        ${READEMPTION_FOLDER}
}

build_coverage_files(){
    reademption
        coverage \
        -p ${COVERAGE_PROCESSES} \
        ${READEMPTION_FOLDER}
}

run_gene_quanti(){
    reademption \
	gene_quanti \
	-p ${GENE_QUANTI_PROCESSES} \
	--features gene \
	--skip_antisense \
	${READEMPTION_FOLDER}
}

run_deseq_analysis(){
    ###########################################################################
    # Perform the following call to get a list of libs that can be used for -l
    #
    # $ ls -1 READemption_analysis/input/reads/ | tr '\n' ','; echo
    #
    # This output of the following call can be used for the conditions (-c)
    # but might need to be adapted manually 
    #
    # $ ls -1 READemption_analysis/input/reads/ | sed -e "s/_Rep.*//" | tr '\n' ','; echo
    ############################################################################
    reademption \
	deseq \
	-l csrA_Rep_1_100k.fastq.bz2,csrA_Rep_2_100k.fastq.bz2,csrA_Rep_3_100k.fastq.bz2,csrA_Rep_4_100k.fastq.bz2,csrA_Rep_5_100k.fastq.bz2,wildtype_Rep_1_100k.fastq.bz2,wildtype_Rep_2_100k.fastq.bz2,wildtype_Rep_3_100k.fastq.bz2,wildtype_Rep_4_100k.fastq.bz2,wildtype_Rep_5_100k.fastq.bz2 \
	-c csrA,csrA,csrA,csrA,csrA,wildtype,wildtype,wildtype,wildtype,wildtype \
	${READEMPTION_FOLDER}
}

run_viz_align(){
    reademption viz_align ${READEMPTION_FOLDER}
}

run_viz_gene_quanti(){
    reademption viz_gene_quanti ${READEMPTION_FOLDER}
}

run_viz_deseq(){
    reademption viz_deseq ${READEMPTION_FOLDER}
}

main
