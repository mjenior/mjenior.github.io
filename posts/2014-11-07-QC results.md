---
layout: post
title:  "QC Results"
date:   2015-12-7
comments: true
---

The bowtie jobs mapping reads to contigs finished last night and I am not very happy with the results.

	# Control
	# reads processed: 115355553
	# reads with at least one reported alignment: 50387032 (43.68%)
	# reads that failed to align: 64968521 (56.32%)

	# Condition 1
	# reads processed: 176339393
	# reads with at least one reported alignment: 28206174 (16.00%)
	# reads that failed to align: 148133219 (84.00%)

	# Condition 2
	# reads processed: 117021700
	# reads with at least one reported alignment: 13417699 (11.47%)
	# reads that failed to align: 103604001 (88.53%)

	# Condition 3
	# reads processed: 389975679
	# reads with at least one reported alignment: 54166939 (13.89%)
	# reads that failed to align: 335808740 (86.11%)

I was hoping for >50% of reads with at least one alignment for each of the datasets.  That's what I was able to achieve with the old install of khmer, which improved % reads mapping to 
contigs by ~15% in each metagenome.  

The percent of reads mapping to contigs for everything but the Conventional community was abysmal this time and there could be a couple of reasons why:

	1.  Megahit is tuned to deal with uneven coverage since it's specifically for metagenomes
	2.  Digital normalization was too greedy and removed useful informaton
	3.  I chose the wrong parameters for either
	
Regardless of what the reason is, it doesn't matter.  In a [post](http://ivory.idyll.org/blog/2014-how-good-is-megahit.html) of his blog, Titus found that Megahit performed poorly when paired with 
digital normalization.  The results I had before may have been a fluke and I'm dropping khmer since I like Megahit more.  I had read this post when I was deciding on assemblers but I didn't remember 
how it ended with comments on combining it with normalization, which is frustrating...

The assemblies without using digital normalization at all are running right now and I'll compare those results later today. Ugh...