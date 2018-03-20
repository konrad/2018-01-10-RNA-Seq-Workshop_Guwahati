#!/usr/bin/env bash

main(){
    INPUT_FOLDER=input
    OUTPUT_FOLDER=STAR_analysis
    GENOME_INDEX_DIR=$OUTPUT_FOLDER/index
    READ_FOLDER=$OUTPUT_FOLDER/reads
    STAR_BIN=/opt/biotools/STAR-2.5.2b/bin/Linux_x86_64_static/STAR #Should be in anaconda
    MAPPING_FOLDER=$OUTPUT_FOLDER/mappings
    READ_PER_FEATURE_FOLDER=$OUTPUT_FOLDER/reads_per_feature
    GENOME_FASTA=${PWD}/Human_data/genome_and_annotations/GRCh38.p10.genome.fa
    ANNOTATION_GTF=${PWD}/Human_data/genome_and_annotations/gencode.v27.annotation.gtf
    ANNOTATION_GFF=${PWD}/Human_data/genome_and_annotations/gencode.v27.basic.annotation.gff3
    READ_SOURCE_FOLDER=${PWD}/Human_data/reads/
    #READ_SOURCE_FOLDER=${PWD}/Human_data/reads_subsample_1M/    
    #READ_SOURCE_FOLDER=${PWD}/Human_data/reads_subsample_100k/

    #create_folders
    #link_and_rename_read_files
    #create_index
    #run_read_alignment
    #index_bam_files
    #compile_mapping_stats
    count_reads_per_feature
}


create_folders(){
    mkdir -p \
    $INPUT_FOLDER \
    $OUTPUT_FOLDER \
    $GENOME_INDEX_DIR \
    $MAPPING_FOLDER \
    $READ_FOLDER \
    $READ_PER_FEATURE_FOLDER                      
}                                                  

link_and_rename_read_files(){                      
    for FILE in $(ls $READ_SOURCE_FOLDER)
    do
    MOD_FILE_NAME=$(echo $FILE | sed -E -e "s/^.{0}//")
    echo $MOD_FILE_NAME
    ln -s $READ_SOURCE_FOLDER/$FILE $READ_FOLDER/$MOD_FILE_NAME
    done
}

create_index(){
    $STAR_BIN \
    --runThreadN 20 \
    --runMode genomeGenerate \
    --genomeDir $GENOME_INDEX_DIR \
    --genomeFastaFiles $GENOME_FASTA \
    --sjdbGTFfile $ANNOTATION_GTF
}

run_read_alignment(){
    for R1_LIB in $(ls $READ_FOLDER/*R1*.fastq.gz)
    do
    OUTPUT_FILE_PREFIX=$(echo $R1_LIB | sed -e "s/R1.fastq.gz/./")
    OUTPUT_FILE_PREFIX=$(basename $OUTPUT_FILE_PREFIX)
    echo $R1_LIB
    R2_LIB=$(echo $R1_LIB | sed "s/_R1\.fastq/_R2\.fastq/")
    echo $R2_LIB
            $STAR_BIN \
            --runMode alignReads \
            --runThreadN 40 \
            --genomeDir $GENOME_INDEX_DIR \
            --readFilesIn $READ_FOLDER/$(basename $R1_LIB) $READ_FOLDER/$(basename $R2_LIB) \
            --readFilesCommand zcat \
            --sjdbGTFfile $ANNOTATION_GTF \
            --outFileNamePrefix $MAPPING_FOLDER/$OUTPUT_FILE_PREFIX \
            --outSAMtype BAM SortedByCoordinate
    done
}

index_bam_files(){
    for BAM in $(ls $MAPPING_FOLDER | grep bam$)
    do
    samtools index $MAPPING_FOLDER/$BAM &
    done
    wait
}

compile_mapping_stats(){
    grep "Uniquely mapped reads %" ${MAPPING_FOLDER}/*Log.final.out \
    | sed -e "s/STAR_analysis\/mappings\///" -e s/:.*\|// -e "s/_.Log.final.out//"\
    > $OUTPUT_FOLDER/Percentage_uniquely_mapped_reads.csv
}

count_reads_per_feature(){
    for LIB in $(ls $READ_FOLDER/*R1*.fastq.gz)
    do
    OUTPUT_FILE_PREFIX=$(echo $LIB | sed -e "s/_R1.fastq.gz//")
    OUTPUT_FILE_PREFIX=$(basename $OUTPUT_FILE_PREFIX)
    echo ${OUTPUT_FILE_PREFIX}
    done
    grep -P "\tgene\t.*protein_coding|^#" ${ANNOTATION_GFF} \
         > tmp_genes_only.gff3                     

    ls $MAPPING_FOLDER/*bam \
        | parallel -P 2 \
               bedtools intersect \
               -S \
               -wa \
               -c \
               -a tmp_genes_only.gff3 \
               -b {} \
               ">" $READ_PER_FEATURE_FOLDER/{/}.csv

    echo -e "Chr\tSource\tFeature\tStart\tEnd\tFrame\tStrand\t\tAttributes" > tmp_combined
    cut -f -9 $READ_PER_FEATURE_FOLDER/Benta_Rep_4_.Aligned.sortedByCoord.out.bam.csv >> tmp_combined 
    for FILE in $(ls $READ_PER_FEATURE_FOLDER)
    do
        CLEANED_NAME=$(echo $FILE | sed "s/.Aligned.sortedByCoord.out.bam.csv//")
        echo $READ_PER_FEATURE_FOLDER/$FILE
        echo $CLEANED_NAME > tmp
        cut -f 10 $READ_PER_FEATURE_FOLDER/$FILE >> tmp
        cp tmp_combined tmp_combined_curr
        paste tmp_combined_curr tmp > tmp_combined
        rm tmp tmp_combined_curr
    done
    mv tmp_combined $OUTPUT_FOLDER/Read_per_features_combined.csv
}
main
