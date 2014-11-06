---
layout: post
title:  "Digital normalization with khmer"
date:   2014-11-05
comments: true
---

The khmer script normalize-by-meadian is pretty picky about the sequence naming convention so be sure to use their provided script for interleaving and renaming sequences.

`python ~/khmer/scripts/interleave-reads.py R1_001.fastq R2_001.fastq -o combined_001.fastq`

Sickle will do quality trimming.

`sickle pe -c combined_001.fastq -M combined_001.trimmed.fastq -t sanger`

Now we can normalize by meadian to remove low and high abuncance k-mers. Here we're using k-mer value of 20 and count of 20. The p indicates paired ends.

`python ~/khmer/scripts/normalize-by-median.py -k 20 -C 20 -x 1e10 -p combined_001.trimmed.fastq`
