# Let's get started with the assembly by mapping the reads to the host genome NOTE: we're leaving the orphaned reads out here as there aren't many and they're also less useful
# Here, we're also using the PacBio assembly of the Ebert lab, v.3.0

bwa mem -t 55 -p dmagna3.0.fasta C1_BSSE_R1.pe.fq.gz | samtools sort -O BAM -o C1_BSSE.align.bam -

# let's have a look at the mapping summary

samtools flagstat C1_BSSE.align.bam > C1.mapping.stat

# Coverage of the parasite isn't super impressive but we can make it work (we still have
# a couple hundred X of a 1.7Mbp genome). Let's get the non-host DNA out (P. ramosa plus other
# stuff) first, we need to filter out mapped reads and then resort by name rather than coordinate

samtools view -b -f 4 C1_BSSE.align.bam | samtools sort -n -o C1_BSSE.align.name.bam -

# Now, let's use bedtools to get the paired reads back out of the bam to do kmer analysis and assembly

bedtools bamtofastq -i C1_BSSE.align.name.bam -fq C1_BSSE_unmapped_R1.fq -fq2 C1_BSSE_unmapped_R2.fq
pigz *.fq

# Now that we have our reads ready let's have a quick look a the kmer spectra to decide on how to select a kmer value for spades
# velvet will not work well for this data due to us probably not having a clean extraction of only 
# P. ramosa data

ls -1 C1_BSSE_unmapped*.fq.gz > list_files
kmergenie list_files



