---
layout: post
title:  "Digital normalization with khmer"
date:   2014-11-05
comments: true
---

When starting from raw sequence reads, the first task is to prep them for assembly. First, we need to interleave them (if paired end reads) and do quality trimming. After this we use [digital normalization](http://khmer.readthedocs.org/en/v1.1/scripts.html#scripts-diginorm) provided by [khmer](https://github.com/ged-lab/khmer) to artificially even out the coverage, which is what most assemblers expect. We can add thse reads back into the analysis later.

The khmer script normalize-by-median is pretty picky about the sequence naming convention so be sure to use their provided script for interleaving and renaming sequences.

`python ~/khmer/scripts/interleave-reads.py R1_001.fastq R2_001.fastq -o combined_001.fastq`

Sickle will do quality trimming.

`sickle pe -c combined_001.fastq -M combined_001.trimmed.fastq -t sanger`

Now we can normalize by median to remove low and high abundance k-mers. Here we're using k-mer value of 20 and count of 20. The p indicates paired ends.

`python ~/khmer/scripts/normalize-by-median.py -k 20 -C 20 -x 1e10 -p combined_001.trimmed.fastq`
