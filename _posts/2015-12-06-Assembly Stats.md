---
layout: post
title:  "Trimming and Normalization"
date:   2015-12-6
comments: true
---

Let's see if I'm trimming data or information...

### Quality Trimming 

To improve the speed and quality of assembly it makes sense to reduce the amount of data (reads) input to the assembler.  However, 
the trick is to reduce data without losing any information.  The first step is using sickle to trim the 3'-ends of reads beads on 
quality scores and discard reads that don't meet a length threshold. You can read more about their algorithm [here](https://github.com/najoshi/sickle), 
on their github page.   

### Digital Normalization

I discussed this in the previous blog post but just to reiterate, with the number of reads I have an assembly would take forever and recurring sequencing 
errors can break up good contigs.

### Results



#### Conventional

Category | Pooled Lanes | Quality Trimming | Digital Normalization
Paired-end | 116784668 | 114103196 | 22821658
Orphan | NA | 1252357 | 1624925
Total | 116784668 | 115355553 | 24446583
% of Pool | NA | 98.78 | **20.93**



#### Cefoperazone

Category | Pooled Lanes | Quality Trimming | Digital Normalization
Paired-end | 178456950 | 174412784 | 43012608
Orphan | NA | 1926609 | 4014358
Total | 178456950 | 176339393 | 47026966
% of Pool | NA | 98.81 | **26.35**



#### Clindamycin

Category | Pooled Lanes | Quality Trimming | Digital Normalization
Paired-end | 118787094 | 115437644 | 10536046
Orphan | NA | 1584056 | 1142605
Total | 118787094 | 117021700 | 11678651
% of Pool | NA | 98.51 | **9.83**



#### Streptomycin

Category | Pooled Lanes | Quality Trimming | Digital Normalization
Paired-end | 395429292 | 385020860 | 2145684
Orphan | NA | 4954819 | 1420062
Total | 395429292 | 389975679 | 3565746
% of Pool | NA | 98.62 | **0.90**


The amount that was taken from the Strep treated metagenome is a little bit alarm, especially when you 
remember that it is a much more diverse community that say Cefoperazone (So it's not just a byproduct of 
low species richness...).  This sample has a whole order of magnitude less reads left after normalization 
compared to any of the others.  I'm not sure how well this will assemble now, but I can tell more once the 
job for mapping reads to contigs finishes.  This will tell me  how much what I assemble looks like what I 
sequenced.  If that's no good, I'll compare it to the assemblies without normalization and see if khmer is 
being too greedy.  The samples were sequenced on 2 lanes simultaneously and then pooled so it's unlikey that 
both lanes sequenced poorly, especially when all other quality metrics are high.

