---
layout: post
title:  "Accounting for PCR Duplications in Read Mapping"
date:   2016-06-02
comments: true
tags: [metagenomics, metatranscriptomics, bioinformatics]
---

It's time for another post about considerations you should make when tackling a metagenomic or metatranscriptomic dataset.  The problem comes in  during library construction, even before sequencing.  The small amount of PCR cycles that are done to add adapters to the end of the nucleotide fragments is enough to create artifacts during the read mapping process downstream when trying to get a handle on gene or transcript abundance.  This is due to the simple fact that when you are look at read mapping counts, you assume that each mapping is an independent event and therefore adds information to your analysis.  If PCR duplications are allowed to persist, this is no longer true as multiple reads will map to the same sequence simply because they are exact copies of one another.  This can be remedied in a couple of ways...


<div style="text-align:center"><img src ="http://mjenior.github.io/images/clones.jpg" width="400" height="200" /></div>


One method is using an R package called [DeSeq](http://bioconductor.org/packages/release/bioc/html/DESeq.html) within the commonly used [Bioconductor](http://bioconductor.org).  What this program does is basically fit your mapping data to an expected distribution for what an ideal distributioin "should" look like.  It looks something like this:

<div style="text-align:center"><img src ="https://www.unc.edu/courses/2008fall/ecol/563/001/images/lectures/lecture13/fig4.png" width="500" height="300" /></div>

I got this image from a [lecture](https://www.unc.edu/courses/2008fall/ecol/563/001/docs/lectures/lecture13.htm) on distributions by Jack Weiss at UNC.  This is known as a negative binomial distribution.  You can imagine the number of unique genes being on the y-axis, while the number of transcript reads mapping to each on the x-axis.  This would illustrate that relatively few genes are being highly transcribed, and most most have low levels of expression.  Normalizing to this style of distribution isn't wrong by any means since all transcript mapping datasets will fit this style of curve if sampled deeply enough, that's just how biology works.  However, it is making some assumptions about your sequencing depth and it doesn't look at the actual mapping coordinates themselves.

The method I use is a little more robust because it looks at the actually similarity of the mapped reads and decides if they are actually identical or not.  You can do this using the MarkDuplicates function within the [Picard](http://broadinstitute.github.io/picard/) toolkit. How it works is by scanning through your SAM file and looks for reads with identical 5' mapping coordinates.  Any matches are marked as duplicates and subsequently removed.  This relies on the probability that multiple strands of nucleic acid fragmented in the exact same place is so impossibly small that any sequence that starts at the same site is almost definitely due to PCR duplication.

Here is an example of how to run 10 Gb of read data through this kind of PCR dereplication:

	/share/apps/rhel6/java/1.8.0/bin/java -Xmx10g -jar /share/apps/rhel6/picard/1.77/MarkDuplicates.jar \
	INPUT=metatranscriptome.sort.merge.sort.bam \
	OUTPUT=metatranscriptome.sort.merge.sort.rmdup.bam \
	METRICS_FILE=metatranscriptome.sort.merge.sort.rmdup.metrics \
	AS=TRUE \
	VALIDATION_STRINGENCY=LENIENT \
	MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
	REMOVE_DUPLICATES=TRUE

After dereplicating a benchmarking dataset, MarkDuplicates found **~75.15%** read duplication.  This would have *heavily* skewed my downstream analysis and is a critical step to any transcript mapping study.  Here is what the output metrics looked like:

	UNPAIRED_READS_EXAMINED	READ_PAIRS_EXAMINED	UNMAPPED_READS	UNPAIRED_READ_DUPLICATES	READ_PAIR_DUPLICATES	READ_PAIR_OPTICAL_DUPLICATES    PERCENT_DUPLICATION	ESTIMATED_LIBRARY_SIZE
	36595704	106878532	61700529	35697350	76225526	61122575	0.751533	53029253

Definitely something to think about when reading these kinds of studies in the future!
