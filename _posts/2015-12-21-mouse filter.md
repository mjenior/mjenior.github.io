---
layout: post
title:  "Results from filtering through mouse genome"
date:   2015-12-21 17:55:47
comments: true
tags: []
image:
  feature: abstract-11.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
---

As I mentioned in the last post, I'm mapping the filtered transcripts to the mus musculus genome (our lab mice) to remove more reads I'm not 
interested in before subsampling.  For reference I used the complete list of annotated mus musculus genes from the KEGG 
database we have on axiom.  With this step done the files should be fully curated and ready to move forward with.

<div style="text-align:center"><img src ="http://the-gist.org/wp-content/uploads/2014/06/800px-Lab_mouse_mg_3276.jpg" width="300" height="200" /></div>

Here's the commands for mapping just for reference:

Paired-end read alignment:

	/home/mljenior/bin/bowtie/bowtie /mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/mus_musculus/mus_db -f -1 ${sample_name}.read1.pool.trim.filt_rRNA.fasta -p 4 -2 ${sample_name}.read2.pool.trim.filt_rRNA.fasta --un ${sample_name}.filter.trimmed.read.fasta
	mv ${sample_name}.filter.trimmed.read_1.fasta cefoperazone_630.read1.pool.trim.filt_rRNA.filt_mus.fasta
	mv ${sample_name}.filter.trimmed.read_2.fasta cefoperazone_630.read2.pool.trim.filt_rRNA.filt_mus.fasta

Orphaned read alignment:

	/home/mljenior/bin/bowtie/bowtie /mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/mus_musculus/mus_db -f ${sample_name}.orphan.pool.trim.filt_rRNA.fasta -p 4 --un ${sample_name}.orphan.pool.trim.filt_rRNA.filt_mus.fasta

---------------------------------------

Unmapped reads from mapping against mouse genome

	# condition1_plus.read1.pool.trim.filt_rRNA.filt_mus.fasta
	# Total sequences: 164655029
	# Total bases: 8470.99 Mb
	
	# condition1_plus.read2.pool.trim.filt_rRNA.filt_mus.fasta
	# Total sequences: 164655029
	# Total bases: 8428.80 Mb

	# condition1_plus.orphan.pool.trim.filt_rRNA.filt_mus.fasta
	# Total sequences: 14957436
	# Total bases: 666.06 Mb

---------------------------------------

Percent of data removed by mouse filter

	Sequences
	read 1:  1.26%
	read 2:  1.26%
	orphan:  1.96%

	Bases
	read 1:  1.26%
	read 2:  1.26%
	orphan:  1.89%

This shows that not a lot of mouse transcript make it into the cecal content and mask the signal I'm hoping to get 
from the datasets.

---------------------------------------

Total percent of data removed

	Sequences
	read 1:  1.37%
	read 2:  1.37%
	orphan:  2.23%

	Bases
	read 1:  1.37%
	read 2:  1.37%
	orphan:  2.14%

This is great news.  It looks like I most likely have primarily bacterial sequence (excluding any possible viral and archeal reads).  

---------------------------------------


Also, it's important to say that these numbers are pretty representative of the filtering for all the other experimental groups.  
Basically I've lost less than 3% of the data by the end of the two step filtering process!

