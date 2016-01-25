---
layout: post
title:  "Metagenomic Assembly QC"
date:   2015-12-08 17:55:47
comments: true
tags: [metagenomics]
---

These results are using the same pipeline as of 12-6-15, but omitting the digital normalization steps. 


#### Control

	# Input file name: Conventional.final.contigs.251.fa
	# File type: Fasta
	# Total sequences: 431204
	# Total bases: 495.00 Mb
	# Sequence N50: 1762
	# Sequence L50: 28
	# Sequence N90: 452
	# Median sequence length: 560
	# Interquartile range: 436
	# Shortest sequence length: 251
	# Longest sequence length: 420252
	# Sequences > 1 kb: 88470
	# Sequences > 5 kb: 10866
	# G-C content: 48.67%
	# Ns included: 0


	# reads processed: 115355553
	# reads with at least one reported alignment: 52825487 (45.79%)
	# reads that failed to align: 62530066 (54.21%)


#### Condition 1

	# Input file name: Cefoperazone.final.contigs.251.fa
	# File type: Fasta
	# Total sequences: 2001183
	# Total bases: 1369.55 Mb
	# Sequence N50: 709
	# Sequence L50: 2143
	# Sequence N90: 430
	# Median sequence length: 583
	# Interquartile range: 329
	# Shortest sequence length: 251
	# Longest sequence length: 306971
	# Sequences > 1 kb: 256222
	# Sequences > 5 kb: 912
	# G-C content: 42.96%
	# Ns included: 0


#### Condition 2

	# Input file name: Clindamycin.final.contigs.251.fa
	# File type: Fasta
	# Total sequences: 467061
	# Total bases: 252.32 Mb
	# Sequence N50: 530
	# Sequence L50: 1132
	# Sequence N90: 398
	# Median sequence length: 483
	# Interquartile range: 175
	# Shortest sequence length: 251
	# Longest sequence length: 139769
	# Sequences > 1 kb: 8790
	# Sequences > 5 kb: 358
	# G-C content: 45.29%
	# Ns included: 0


	# reads processed: 117021700
	# reads with at least one reported alignment: 55021810 (47.02%)
	# reads that failed to align: 61999890 (52.98%)


#### Condition 3

	Unfortunately there were some errors during assembly so I'm repeating the Streptomycin assembly

### Assemblies of Great Prairie Soil Metagenome Grand Challenge Datasets

As a standard of comparison I used Megahit's results from the [Assemblies of Great Prairie Soil Metagenome Grand Challenge Datasets](https://hku-bal.github.io/megabox/GrePraGChallenge.html).  The 
challenge was to assemble these extremely complex and historically difficult to assemble metagenomes from soil samples across the country.  They posted a few quality metrics 
they achieved and they compare pretty favorably with what I was able to get out of my data.

	Wisconsin, Switchgrass soil metagenome reference core - MEGAHIT v1.0.3
	Contig length cutoff (bp)	200
	Number of contigs	4,783,921
	Total size (bp)	2,589,776,155
	Largest contig (bp)	65,654
	N50 (bp)	550

	Kansas Native Prairie soil metagenome reference core - MEGAHIT v1.0.1
	Contig length cutoff (bp)	200
	Number of contigs	47,985,585
	Total size (bp)	27,878,228,835
	Largest contig (bp)	246,919
	N50 (bp)	629

	Iowa Native Prairie soil metagenome reference core - MEGAHIT v1.0.1
	Contig length cutoff (bp)	200
	Number of contigs	10,986,357
	Total size (bp)	7,175,891,749
	Largest contig (bp)	313,620
	N50 (bp)	738


On average, the N50s in my assemblies are 36% longer than the soil assemblies.  Similarly the average longest contig in my assembly is 27% longer.


I should also note that I've been using version 0.3.2 of MEGAHIT and the same assemblies are running now using the current version of 1.0.3.  They 
programmers say they have improved assembly quality with the newer version so I'll do that comparison in a future post.