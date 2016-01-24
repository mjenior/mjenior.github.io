---
layout: post
title:  "Aligning reads to SILVA"
date:   2015-12-14 17:55:47
comments: true
---

As I was thinking about subsampling reads to make more fair comparisons I realized that there is probably 
still at least a small proportion of contaminating rRNA reads left in the transcriptomes.  If I subsample 
before filtering out those reads, I may be losing out of data mapping to genes I care about downstream.  In 
order to avoid this I decided to map the reads with Bowtie to the SILVA rRNA gene database and use only 
those reads that fail to find a match for anything later on in the pipeline.


I started by getting the non-redundant full length sequences from release 123 off of the [mothur](http://www.mothur.org/wiki/Silva_reference_files) 
site.  This file has sequences from bacteria (152308), eukaryotes (16209), and archea (3901).  It looks like this:

	AB006051.LobTirol 
	......................................................ATG---------CGTACGCCATGCGTG-------
	GGCTAGACT------CGTAC------------------------------ACGTACGACACGTCCATAGACTCGATAC----------
	...
	
In order to align reads to this file, I needed to remove the gaps before making the Bowtie database.  I used the mothur command that removes gaps as follows:

	Degap.seqs(fasta=silva.nr_v123.align)
	
This gives you a fasta file with just sequence names and nucleic acids remaining, no more gaps.  Making the bowtie database is almost as simple with 
the follow command:

	/home/mljenior/bin/bowtie/bowtie-build silva.nr_v123.ng.fasta silva_db
	
Now it's ready to be used for filtering out rRNA reads from my metatranscriptomes.  I'll post the results from how well it does probably later this week.