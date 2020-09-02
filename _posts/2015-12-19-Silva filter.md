---
layout: post
title:  "Results from filtering reads through SILVA"
date:   2015-12-18 17:55:47
comments: true
tags: [metatranscriptomics, star wars]
---

I finished mapping the read files to the Silva datase.  Using it as a filter for rRNA reads 
prior to subsampling the files to the same number of sequences appears to be the best way to give equal representation of each 
sample set.  By pulling out all of the rRNA reads, I focus the analysis more on mRNA (ignoring tRNA and other non-coding 
RNA contamination).

As a refresher:  "SILVA provides comprehensive, quality checked and regularly updated datasets of aligned small (16S/18S, SSU) 
and large subunit (23S/28S, LSU) ribosomal RNA (rRNA) sequences for all three domains of life (Bacteria, Archaea and Eukarya)."


Paired-end read alignment:

	/home/mljenior/bin/bowtie/bowtie /mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/silva/silva_db -f -1 ${sample_name}.read1.pool.trim.fasta -p 4 -2 ${sample_name}.read2.pool.trim.fasta --un ${sample_name}.filter.trimmed.read.fasta
	
Orphaned read alignment:

	/home/mljenior/bin/bowtie/bowtie /mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/silva/silva_db -f ${sample_name}.orphan.pool.trim.fasta -p 4 --un ${sample_name}.orphan.pool.trim.filter.fasta


---------------------------------------

Fasta-formatted reads following pooling and quality trimming

	# condition1_plus.read1.pool.trim.fasta
	# Total sequences: 166947462
	# Total bases: 8588.91 Mb

	# Input file name: condition1_plus.read2.pool.trim.fasta
	# Total sequences: 166947462
	# Total bases: 8545.94 Mb

	# Input file name: condition1_plus.orphan.pool.trim.fasta
	# Total sequences: 15298814
	# Total bases: 680.59 Mb


---------------------------------------

Unmapped reads from filtering through the SILVA database

	# condition1_plus.read1.trimmed.filter.fasta
	# Total sequences: 166760343
	# Total bases: 8579.28 Mb
	
	# condition1_plus.read2.trimmed.filter.fasta
	# Total sequences: 166760343
	# Total bases: 8536.41 Mb

	# condition1_plus.orphan.pool.trim.filter.fasta
	# Total sequences: 15257237
	# Total bases: 678.89 Mb


---------------------------------------

Percent of data removed from each file

	Sequences
	read 1:  0.11%
	read 2:  0.11%
	orphan:  0.27%

	Bases
	read 1:  0.11%
	read 2:  0.11%
	orphan:  0.25%

This seems to indicate that the rRNA depletion worked really well and we didn't do much useless sequencing on that 
end at least!  I'll move forward with these rRNA depleted files from now on.

---------------------------------------


Thinking about it some more, I should also be filtering through the mus musculus genome...

I'll submit that job now and we will see how many sequences are lost tomorrow.  After that 
I need to subsample the paired-end and orphan reads to the lowest common denominator for each 
type of file, then the reads should finally be ready for mapping to genomes / metagenomes.
