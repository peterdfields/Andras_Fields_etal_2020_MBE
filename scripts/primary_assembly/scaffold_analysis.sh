### First we need to get the subset of P. ramosa contigs out of the larger assembly file using seqtk

seqtk subseq C1_metaspades.fasta contig.lst > C1_metaspades_subset.fasta

### Now we need to remap the reads in order to prepare an input for BESST

bwa index C1_metaspades_subset.fasta
bwa mem -t 55 C1_metaspades_subset.fasta C1_BSSE_unmapped_R1.fq.gz C1_BSSE_unmapped_R2.fq.gz \
 | samtools sort -O BAM -o C1_metaspades_subset.align.bam -
samtools index C1_metaspades_subset.align.bam

# Now, let's use this bam file for the scaffolding
runBESST -c C1_metaspades_subset.fasta -f C1_metaspades_subset.align.bam -o metaspades.scaffold -orientation fr

# It worked! We now have a single large scaffold which merged the smaller contigs. However, we do have a gap of Ns. We will move to
# polishing using Sanger seqeuncing. See manuscript for details.
