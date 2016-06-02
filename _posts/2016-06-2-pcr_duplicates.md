---
layout: post
title:  "Accounting for PCR Duplications in Read Mapping"
date:   2016-06-02
comments: true
tags: [metagenomics, metatranscriptomics, bioinformatics]
---

It's time for another post about considerations you should make when tackling a metagenomic or metatranscriptomic dataset.  The problem comes in  during library construction, even before sequencing.  The small amount of PCR cycles that are done to add adapters to the end of the nucleotide fragments is enough to create artifacts during the read mapping process downstream when trying to get a handle on gene or transcript abundance.  This is due to the simple fact that when you are look at read mapping counts, you assume that each mapping is an independent event and therefore adds information to your analysis.  If PCR duplications are allowed to persist, this is no longer true as multiple reads will map to the same sequence simply because they are exact copies of one another.  This can be remedied in a couple of ways...


<div style="text-align:center"><img src ="http://mjenior.github.io/images/clones" width="400" height="250" /></div>


One method is using an R package called [DeSeq](http://bioconductor.org/packages/release/bioc/html/DESeq.html) within the commonly used [Bioconductor](http://bioconductor.org).  What this program does is fit your mapping data to an expected distribution for what read mapping data "should" look like.  


image of negative binomial distribution



The method I use is a little more robust because it looks at the actually similarity of the mapped reads and decides if they are actually identical or not.  You can do this using the MarkDuplicates function within the [Picard](http://broadinstitute.github.io/picard/) toolkit. How it works is by scanning through your SAM file and looks for reads with identical 5' mapping coordinates.  Any matches are marked as duplicates and subsequently removed.  This relies on the probability that multiple strands of nucleic acid fragmented in the exact same place is so impossibly small that any sequence that starts at the same site is almost definitely due to PCR duplication.