SRA_IDS_BACTERIA="
SRR5912861=csrA_kan_Rep1
SRR5912860=csrA_kan_Rep2
SRR5912859=csrA_kan_Rep3
SRR5912858=csrA_kan_Rep4
SRR5912857=csrA_kan_Rep5
SRR5912856=wildtype_Rep1
SRR5912855=wildtype_Rep2
SRR5912854=wildtype_Rep3
SRR5912853=wildtype_Rep4
SRR5912852=wildtype_Rep5
SRR5912851=csrA_kan_other_Rep1
SRR5912850=csrA_kan_other_Rep2
SRR5912849=csrA_kan_other_Rep3
SRR5912848=csrA_kan_other_Rep4
SRR5912847=csrA_kan_other_Rep5
SRR5912846=wildtype_other_Rep1
SRR5912845=wildtype_other_Rep2
SRR5912844=wildtype_other_Rep3
SRR5912843=wildtype_other_Rep4
SRR5912842=wildtype_other_Rep5
"
SRA_IDS_HUMAN="






"

main(){
    set_variables
    create_folder_structure
    download_human_genome_annotation
    decompress_files
    #download_human_RNA_data
    download_bacterial_genome_annotation
    download_bacterial_RNA_data
#   make_unwritetable

}

set_variables(){
    HUMAN_INPUT_FOLDER=HumanGenome_and_Annotations
    BACTERIA_INPUT_FOLDER=BacterialGenome_and_Annotations
    RNASEQ_BACTERIA_INPUT_FOLDER=Bacterial_RNA-Seq
    RNASEQ_HUMAN_INPUT_FOLDER=Human_RNA-Seq
    VERSION=27
    NAME=GUIST_Guwahati_University
    DATE=$(date +%Y-%m-%d)
    ROOT_FOLDER_NAME=$DATE-$NAME
}

create_folder_structure(){
    for FOLDER in analyses bin data docs
    do
    if ! [ -d $FOLDER ]
    then
        mkdir -p $ROOT_FOLDER_NAME/$FOLDER
    fi
    done
}

download_human_genome_annotation(){
    SOURCE=ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_${VERSION}/
    wget -cP $ROOT_FOLDER_NAME/data/$HUMAN_INPUT_FOLDER \
    $SOURCE/gencode.v${VERSION}.annotation.gff3.gz \
    $SOURCE/gencode.v${VERSION}.2wayconspseudos.gff3.gz \
    $SOURCE/gencode.v${VERSION}.long_noncoding_RNAs.gff3.gz \
    $SOURCE/gencode.v${VERSION}.tRNAs.gff3.gz 
    $SOURCE/GRCh38.p10.genome.fa.gz
    rm *.gz
}

decompress_files(){
    for FILE in $(ls $ROOT_FOLDER_NAME/data/$HUMAN_INPUT_FOLDER)
    do
    NEW_NAME=$(echo $FILE | sed "s/.gz//")
    zcat  $ROOT_FOLDER_NAME/data/${HUMAN_INPUT_FOLDER}/${FILE} >  $ROOT_FOLDER_NAME/data/${HUMAN_INPUT_FOLDER}/${NEW_NAME} &
    done
    wait
}


download_human_RNA_data(){
    
echo "test"
    for SRA_LIST in $SRA_IDS_HUMAN
    do
    echo $SRA_LIST
    PATTERN=$(echo $SRA_LIST | cut -f 1 -d=)
    echo $PATTERN
    NAME=$(echo $SRA_LIST | cut -f 2 -d=)
    echo $NAME
    fastq-dump --accession ${PATTERN} --outdir $ROOT_FOLDER_NAME/data/$RNASEQ_HUMAN_INPUT_FOLDER --gzip
    mv $ROOT_FOLDER_NAME/data/${RNASEQ_HUMAN_INPUT_FOLDER}/${PATTERN}.fastq.gz $ROOT_FOLDER_NAME/data/${RNASEQ_HUMAN_INPUT_FOLDER}/${NAME}.fq.gz
    done 


}

download_bacterial_genome_annotation(){
    #Ecoli - k12
    SOURCE=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/
    wget -cP $ROOT_FOLDER_NAME/data/$BACTERIA_INPUT_FOLDER \
    ${SOURCE}/*fna.gz \
    ${SOURCE}/*gff.gz
    gunzip $ROOT_FOLDER_NAME/data/$BACTERIA_INPUT_FOLDER/*gz
    rm $ROOT_FOLDER_NAME/data/$BACTERIA_INPUT_FOLDER/*cds_from_genomic.fna
    rm $ROOT_FOLDER_NAME/data/$BACTERIA_INPUT_FOLDER/*rna_from_genomic.fna
    for FASTA in $(ls $ROOT_FOLDER_NAME/data/$BACTERIA_INPUT_FOLDER | grep fna$)
    do
    mv $ROOT_FOLDER_NAME/data/$BACTERIA_INPUT_FOLDER/$FASTA $ROOT_FOLDER_NAME/data/${BACTERIA_INPUT_FOLDER}/$(basename $FASTA .fna).fa
    done
}

download_bacterial_RNA_data(){
    for SRA_LIST in $SRA_IDS_BACTERIA
    do
    echo $SRA_LIST
    PATTERN=$(echo $SRA_LIST | cut -f 1 -d=)
    echo $PATTERN
    NAME=$(echo $SRA_LIST | cut -f 2 -d=)
    echo $NAME
    fastq-dump --accession ${PATTERN} --outdir $ROOT_FOLDER_NAME/data/$RNASEQ_BACTERIA_INPUT_FOLDER --gzip
    mv $ROOT_FOLDER_NAME/data/${RNASEQ_BACTERIA_INPUT_FOLDER}/${PATTERN}.fastq.gz $ROOT_FOLDER_NAME/data/${RNASEQ_BACTERIA_INPUT_FOLDER}/${NAME}.fq.gz
    done 


}


make_unwritetable(){
        chmod -R ugo-w ${ROOT_FOLDER_NAME}
}


main
