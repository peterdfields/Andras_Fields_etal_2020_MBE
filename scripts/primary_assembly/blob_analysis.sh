####### In order to do the blobology analysis one needs to first generate taxon matches for the full contig set
### use environment with blast and diamond installed
### database for blast is ncbi nt; database for diamond is uniprot refseq

# first, blast

blastn -db nt \
       -query C1_metaspades.fasta \
       -outfmt "6 qseqid staxids bitscore std" \
       -max_target_seqs 10 \
       -max_hsps 1 \
       -evalue 1e-25 \
       -out blast.out

# second, diamond

diamond blastx \
        --query C1_metaspades.fasta  \
        --db /home/peter/bioinformatics/uniprot/reference_proteomes.dmnd \
        --outfmt 6 qseqid staxids bitscore qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \
        --sensitive \
        --max-target-seqs 1 \
        --evalue 1e-25 \
        > diamond.out

### we can also take a look at the coverage of individual contigs from the input read dataset used for the assembly

bwa index C1_metaspades.fasta
bwa mem -t 55 C1_metaspades.fasta C1_BSSE_unmapped_R1.fq.gz C1_BSSE_unmapped_R2.fq.gz | samtools sort -O BAM -o C1_metaspades.align.bam -

### now we can load these hits and coverage into a blobtools project

blobtools create -i C1_metaspades.fasta -b C1_metaspades.align.bam \
 -t blast.out -t diamond.out -o FI-OER-3-3.blobtools
blobtools view -i C1_metaspades.blobtools.blobDB.json
blobtools plot -i C1_metaspades.blobtools.blobDB.json

### Based upon the blob analysis we have about 12 contigs which show either/both a Pasteuria annotation or 
### the expected coverage. I had a look at the assembly graph in Bandage and this holds up well, wherein
### there are a few repeats that are breaking these contigs. One of the contigs is close to ~75% the expected length
### and then all the other contigs are pretty small. So let's move to scaffolding.
